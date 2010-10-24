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

import com.sun.javafx.runtime.FXObject;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import javax.swing.SwingUtilities;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

/**
 * Abstract base class for Java to FX synchronization
 */
public abstract class AbstractJava2Fx {
  @NotNull
  protected final Object bindee;
  @NotNull
  protected final FXObject binder;
  @NotNull
  protected final Map<JavaProperty, FXVar> boundVars = new HashMap<JavaProperty, FXVar>();
  @NotNull
  protected final ConverterSupport<FXVar> converterSupport = new ConverterSupport<FXVar>();

  protected AbstractJava2Fx( @NotNull Object bindee, @NotNull FXObject binder ) {
    this.bindee = bindee;
    this.binder = binder;
  }

  /**
   * Returns the bound vor the given property name
   *
   * @param property the property
   * @return the bound var (null if there is no bound var for that property name)
   */
  @Nullable
  protected FXVar getBoundVar( @NotNull @NonNls JavaProperty property ) {
    return boundVars.get( property );
  }

  /**
   * Binds a property.
   * This method uses reflection to get the initial value of the property. If you want to set the initial value manually use
   * {@link #bind(String, Converter, Object)} instead.
   *
   * @param propertyName the name of the property
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   */
  public void bind( @NotNull String propertyName ) throws NoSuchFieldException, IllegalAccessException {
    bind( propertyName, null );
  }

  /**
   * Binds a property.
   * This method uses reflection to get the initial value of the property. Use {@link #bind(String, Converter, Object)} to avoid
   * the usage of reflection.
   *
   * @param propertyName the name of the property
   * @param converter    the (optional) converter
   * @param <J>          the property type on the Java side
   * @param <X>          the property type on the JavaFX side
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   */
  public <J, X> void bind( @NotNull String propertyName, @Nullable Converter<J, X> converter ) throws NoSuchFieldException, IllegalAccessException {
    bind( propertyName, converter, ( J ) getInitialValue( new JavaProperty( propertyName ) ) );
  }

  /**
   * Binds a property
   *
   * @param propertyName the name of the property
   * @param converter    the (optional) converter
   * @param initialValue the initial value (unconverted). This parameter may be used to avoid the usage of reflection
   * @param <J>          the property type on the Java side
   * @param <X>          the property type on the JavaFX side
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   */
  public <J, X> void bind( @NotNull String propertyName, @Nullable Converter<J, X> converter, @Nullable J initialValue ) throws NoSuchFieldException, IllegalAccessException {
    FXVar fxVar = new FXVar( binder.getClass(), propertyName );
    JavaProperty javaProperty = new JavaProperty( propertyName );
    bind( javaProperty, fxVar, converter, initialValue );
  }

  public <J, X> void bind( @NotNull JavaProperty javaProperty, @NotNull FXVar fxVar ) throws NoSuchFieldException, IllegalAccessException {
    bind( javaProperty, fxVar, null );
  }

  public <J, X> void bind( @NotNull JavaProperty javaProperty, @NotNull FXVar fxVar, @Nullable Converter<J, X> converter ) throws NoSuchFieldException, IllegalAccessException {
    bind( javaProperty, fxVar, converter, getInitialValue( javaProperty ) );
  }

  /**
   * Binds a property
   *
   * @param javaProperty the java property
   * @param fxVar        the fx var
   * @param converter    the optional converter
   * @param initialValue the initial value
   * @param <J>          the property type on the Java side
   * @param <X>          the property type on the JavaFX side
   */
  public <J, X> void bind( @NotNull JavaProperty javaProperty, @NotNull FXVar fxVar, @Nullable Converter<J, X> converter, @Nullable Object initialValue ) {
    boundVars.put( javaProperty, fxVar );

    converterSupport.store( fxVar, converter );

    //Set the initial value
    setVar( fxVar, initialValue );
  }

  /**
   * Returns the initial value of the property of the bindee.
   *
   * @param property the property
   * @return the initial value
   *
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   */
  @Nullable
  protected abstract Object getInitialValue( @NotNull @NonNls JavaProperty property ) throws NoSuchFieldException, IllegalAccessException;

  /**
   * Returns the initial value of the property using reflection.
   * It is expected to contain a field with given name
   *
   * @param property the property
   * @return the initial value
   */
  @Nullable
  protected Object getValueByReflection( @NotNull @NonNls JavaProperty property ) throws NoSuchFieldException, IllegalAccessException {
    Field field = bindee.getClass().getDeclaredField( property.getPropertyName() );
    field.setAccessible( true );
    return field.get( bindee );
  }

  /**
   * This method must only be called from EDT!
   *
   * @param property the property
   * @param value    the value
   */
  protected void setVar( @NotNull @NonNls JavaProperty property, @Nullable Object value ) {
    FXVar fxVar = getBoundVar( property );
    if ( fxVar == null ) {
      return;
    }

    setVar( fxVar, value );
  }

  /**
   * This method must only be called from EDT
   *
   * @param fxVar the fxVar
   * @param value the new value
   */
  protected void setVar( @NotNull FXVar fxVar, @Nullable Object value ) {
    assert SwingUtilities.isEventDispatchThread();

    Object convertedValue = converterSupport.convertIfNecessary( fxVar, value );
    binder.set$( fxVar.getVarNumField(), convertedValue );
  }

  @NotNull
  public Object getBindee() {
    return bindee;
  }

  @NotNull
  public FXObject getBinder() {
    return binder;
  }
}
