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
import org.apache.commons.beanutils.PropertyUtilsBean;
import org.jetbrains.annotations.NonNls;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.lang.reflect.InvocationTargetException;

/**
 * Binder that calls setters using a given strategy on a java object.
 * <p/>
 * This bridge offers a way to updated java objects when JavaFX objects are updated.
 */
public class Fx2Setter extends AbstractFX2Java {
  @NotNull
  private final Object binder;
  @NotNull
  private final SetterStrategy setterStrategy;

  public Fx2Setter( @NotNull FXObject bindee, @NotNull Object binder, @NotNull SetterStrategy setterStrategy ) {
    super( bindee );
    this.binder = binder;
    this.setterStrategy = setterStrategy;
  }

  @Override
  protected void commitInitially( @NotNull @NonNls JavaProperty property, @Nullable Object initialValue ) {
    set( property, initialValue );
  }

  @Override
  protected void commit( @NotNull FXVar fxVar, @NotNull @NonNls JavaProperty property, @Nullable Object newValue ) {
    set( property, newValue );
  }

  @Override
  protected void prepareForUpdate( @NotNull FXVar fxVar ) {
    //do nothing...
  }

  protected void set( @NotNull @NonNls JavaProperty property, @Nullable Object value ) {
    setterStrategy.set( binder, property, value );
  }

  /**
   * Setter strategy that is used to call the setters on the java objects.
   * For performance reasons this strategy can be implemented using if/else cascades instead of using reflection.
   */
  public interface SetterStrategy {
    /**
     * Sets the value for the given property name
     *
     * @param object   the object
     * @param property the property
     * @param value    the new value
     */
    void set( @NotNull Object object, @NotNull @NonNls JavaProperty property, @Nullable Object value );
  }

  /**
   * This strategy uses reflection to call the setters.
   * It is necessary to add a dependency to "commons-beanutils" to use this class properly:
   * <pre>
   * &lt;dependency&gt;
   *  &lt;groupId&gt;commons-beanutils&lt;/groupId&gt;
   *  &lt;artifactId&gt;commons-beanutils&lt;/artifactId&gt;
   * &lt;/dependency&gt;
   * <p/>
   * </pre>
   */
  public static class ReflectionSetterStrategy implements SetterStrategy {

    private final PropertyUtilsBean propertyUtilsBean = new PropertyUtilsBean();

    @Override
    public void set( @NotNull Object object, @NotNull @NonNls JavaProperty property, @Nullable Object value ) {
      try {
        propertyUtilsBean.setSimpleProperty( object, property.getPropertyName(), value );
      } catch ( InvocationTargetException e ) {
        throw new RuntimeException( e.getTargetException() );
      } catch ( Exception e ) {
        throw new RuntimeException( e );
      }
    }

  }
}
