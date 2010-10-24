/**
 * Copyright (C) cedarsoft GmbH.
 *
 * Licensed under the GNU General Public License version 3 (the "License")
 * with Classpath Exception; you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *         http://www.cedarsoft.org/gpl3ce
 *         (GPL 3 with Classpath Exception)
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3 only, as
 * published by the Free Software Foundation. cedarsoft GmbH designates this
 * particular file as subject to the "Classpath" exception as provided
 * by cedarsoft GmbH in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 3 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 3 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact cedarsoft GmbH, 72810 Gomaringen, Germany,
 * or visit www.cedarsoft.com if you need additional information or
 * have any questions.
 */

package com.cedarsoft.fx;

import com.sun.javafx.runtime.DependentsManager;
import com.sun.javafx.runtime.FXBase;
import com.sun.javafx.runtime.FXObject;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.List;

/**
 * Abstract base class for synchronization from FX to Java.
 * Use the {@link #bind(FXVar, JavaProperty, Converter, boolean)} method to bind vars to java properties.
 * <p/>
 * There is also a factory ({@link com.cedarsoft.fx.JavaFxBridge}) that can be used to create mappings.
 *
 * @noinspection AbstractClassExtendsConcreteClass
 */
public abstract class AbstractFX2Java extends FXBase {
  @NotNull
  protected final FXObject bindee;
  @NotNull
  protected final List<FXVar> fxVars = new ArrayList<FXVar>();
  @NotNull
  protected final List<JavaProperty> javaProperties = new ArrayList<JavaProperty>();
  @NotNull
  protected final ConverterSupport<FXVar> converterSupport = new ConverterSupport<FXVar>();

  /**
   * Creates a new bridge
   *
   * @param bindee the bindee (the FX source)
   */
  protected AbstractFX2Java( @NotNull FXObject bindee ) {
    super( false );
    initialize$( true );

    this.bindee = bindee;
  }

  /**
   * Binds the given var
   *
   * @param varName the name of the var
   */
  public void bind( @NotNull String varName ) throws NoSuchFieldException, IllegalAccessException {
    bind( varName, null );
  }

  /**
   * Binds the given var
   *
   * @param varName   the name of the var
   * @param converter the (optional) converter
   * @param <X>       the property type on the JavaFX side
   * @param <J>       the property type on the Java side
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   */
  public <X, J> void bind( @NotNull String varName, @Nullable Converter<X, J> converter ) throws NoSuchFieldException, IllegalAccessException {
    bind( varName, converter, true );
  }

  /**
   * Binds the given property name.
   *
   * @param propertyName    the property name
   * @param converter       the (optional) converter
   * @param commitInitially whether to commit the action initially
   * @param <X>             the JavaFX type of the property
   * @param <J>             the Java type of the property
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   */
  public <X, J> void bind( @NotNull String propertyName, @Nullable Converter<X, J> converter, boolean commitInitially ) throws NoSuchFieldException, IllegalAccessException {
    FXVar fxVar = new FXVar( bindee.getClass(), propertyName );
    JavaProperty javaProperty = new JavaProperty( propertyName );
    bind( fxVar, javaProperty, converter, commitInitially );
  }

  public <X, J> void bind( @NotNull FXVar fxVar, @NotNull JavaProperty javaProperty ) {
    bind( fxVar, javaProperty, null );
  }

  public <X, J> void bind( @NotNull FXVar fxVar, @NotNull JavaProperty javaProperty, @Nullable Converter<X, J> converter ) {
    bind( fxVar, javaProperty, converter, true );
  }

  public <X, J> void bind( @NotNull FXVar fxVar, @NotNull JavaProperty javaProperty, @Nullable Converter<X, J> converter, boolean commitInitially ) {
    int index = addEntry( fxVar, javaProperty );

    converterSupport.store( fxVar, converter );
    DependentsManager.addDependent( bindee, fxVar.getVarNumField(), this, index );

    //fire the event for the initial value
    if ( commitInitially ) {
      Object initialValue = bindee.get$( fxVar.getVarNumField() );
      commitInitially( javaProperty, converterSupport.convertIfNecessary( fxVar, initialValue ) );
    }
  }

  /**
   * Adds an entry
   *
   * @param fxVar        the var
   * @param javaProperty the property
   * @return the index of this entry
   */
  protected int addEntry( @NotNull FXVar fxVar, @NotNull JavaProperty javaProperty ) {
    int index = fxVars.size();
    fxVars.add( fxVar );
    javaProperties.add( javaProperty );
    return index;
  }

  @NotNull
  private FXVar getEntry( int depNum ) {
    return fxVars.get( depNum );
  }

  @NotNull
  private JavaProperty getProperty( int depNum ) {
    return javaProperties.get( depNum );
  }

  /**
   * Commits initially
   *
   * @param property     the java property
   * @param initialValue the initial value (that has been converted if necessary)
   */
  protected abstract void commitInitially( @NotNull @NonNls JavaProperty property, @Nullable Object initialValue );

  /**
   * @noinspection DollarSignInName
   */
  @Override
  public boolean update$( FXObject src, int depNum, int startPos, int endPos, int newLength, int phase ) {
    FXVar fxVar = getEntry( depNum );
    if ( phase == FXObject.PHASE_TRANS$CASCADE_INVALIDATE ) {
      prepareForUpdate( fxVar );
    } else if ( phase == FXObject.PHASE_TRANS$CASCADE_TRIGGER ) {
      Object newValue = src.get$( fxVar.getVarNumField() );
      JavaProperty property = getProperty( depNum );
      commit( fxVar, property, converterSupport.convertIfNecessary( fxVar, newValue ) );
    } else {
      throw new IllegalStateException( "Invalid phase: " + phase );
    }

    super.update$( src, depNum, startPos, endPos, newLength, phase );
    return true;
  }

  /**
   * Commits the value
   *
   * @param fxVar    the fx var
   * @param newValue the new value (that has been converted if necessary)
   */
  protected abstract void commit( @NotNull FXVar fxVar, @NotNull @NonNls JavaProperty property, @Nullable Object newValue );

  /**
   * Is called before a var is updated
   *
   * @param fxVar the fx var
   */
  protected abstract void prepareForUpdate( @NotNull FXVar fxVar );

  @NotNull
  public FXObject getBindee() {
    return bindee;
  }
}
