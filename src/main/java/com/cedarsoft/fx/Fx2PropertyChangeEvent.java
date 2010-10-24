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
import com.sun.javafx.runtime.annotation.Public;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.util.HashMap;
import java.util.Map;

/**
 * This is a bridge that connects a PropertyChangeSupport to one or more JavaFX vars.
 * <p/>
 * This bridge does use reflection only to set things up! Whenever a var is updated there no(!) reflection is used!
 * Therefore the performance is quite good.
 * <p/>
 * <p/>
 * The Code might look like that:
 * <pre>
 * FXObject fxObject = ...
 * Fx2PropertyChangeEvent bridge = Fx2PropertyChangeEvent.bindProperties( "name", "id" ).to( fxObject );
 * bridge.addPropertyChangeListener( "name", new PropertyChangeListener(){...} );
 * </pre>
 */
@Public
public class Fx2PropertyChangeEvent extends AbstractFX2Java {
  @NotNull
  private final PropertyChangeSupport pcs;
  @NotNull
  private final Map<FXVar, Object> oldValues = new HashMap<FXVar, Object>();

  public Fx2PropertyChangeEvent( @NotNull FXObject bindee ) {
    this( bindee, null );
  }

  public Fx2PropertyChangeEvent( @NotNull FXObject bindee, @Nullable PropertyChangeSupport pcs ) {
    super( bindee );
    this.pcs = pcs == null ? new PropertyChangeSupport( this ) : pcs;
  }

  @Nullable
  private Object popOldValue( @NotNull FXVar fxVar ) {
    return oldValues.remove( fxVar );
  }

  private void storeOldValue( @NotNull FXVar fxVar, @Nullable Object oldValue ) {
    oldValues.put( fxVar, oldValue );
  }

  public void addPropertyChangeListener( PropertyChangeListener listener ) {
    pcs.addPropertyChangeListener( listener );
  }

  public void removePropertyChangeListener( PropertyChangeListener listener ) {
    pcs.removePropertyChangeListener( listener );
  }

  public void addPropertyChangeListener( String propertyName, PropertyChangeListener listener ) {
    pcs.addPropertyChangeListener( propertyName, listener );
  }

  public void removePropertyChangeListener( String propertyName, PropertyChangeListener listener ) {
    pcs.removePropertyChangeListener( propertyName, listener );
  }

  @NotNull
  public PropertyChangeSupport getPcs() {
    return pcs;
  }

  @Override
  protected void commitInitially( @NotNull @NonNls JavaProperty property, @Nullable Object initialValue ) {
    pcs.firePropertyChange( new PropertyChangeEvent( bindee, property.getPropertyName(), null, initialValue ) );
  }

  @Override
  protected void commit( @NotNull FXVar fxVar, @NotNull @NonNls JavaProperty property, @Nullable Object newValue ) {
    Object oldValue = converterSupport.convertIfNecessary( fxVar, popOldValue( fxVar ) );
    pcs.firePropertyChange( new PropertyChangeEvent( bindee, property.getPropertyName(), oldValue, newValue ) );
  }

  @Override
  protected void prepareForUpdate( @NotNull FXVar fxVar ) {
    Object oldValue = bindee.get$( fxVar.getVarNumField() );
    storeOldValue( fxVar, oldValue );
  }

  /**
   * Binds the given property names
   *
   * @param propertyNames the property names
   * @return the fluent factory used to create a Fx2PropertyChangeEvent
   */
  @NotNull
  public static FluentFactory bindProperties( @NotNull @NonNls String... propertyNames ) {
    return new FluentFactory( propertyNames );
  }

  /**
   * Binds the given property names
   *
   * @param propertyNames the property names
   * @return the fluent factory used to create a Fx2PropertyChangeEvent
   */
  @NotNull
  public static FluentFactory bind( @NotNull @NonNls String... propertyNames ) {
    return bindProperties( propertyNames );
  }

  /**
   * Fluent factory implementation
   */
  public static class FluentFactory {
    @NotNull
    private final String[] propertyNames;

    private FluentFactory( @NonNls @NotNull String[] propertyNames ) {
      //noinspection AssignmentToCollectionOrArrayFieldFromParameter
      this.propertyNames = propertyNames;
    }

    /**
     * Binds the property names to the given bindee
     *
     * @param bindee the bindee the properties are bound to
     * @return the bridge
     *
     * @noinspection InstanceMethodNamingConvention
     */
    @NotNull
    public Fx2PropertyChangeEvent to( @NotNull FXObject bindee ) throws NoSuchFieldException, IllegalAccessException {
      if ( propertyNames.length == 0 ) {
        throw new IllegalArgumentException( "Need at least one property to bind to" );
      }

      Fx2PropertyChangeEvent bridge = new Fx2PropertyChangeEvent( bindee );
      for ( String propertyName : propertyNames ) {
        bridge.bind( propertyName );
      }
      return bridge;
    }
  }
}


