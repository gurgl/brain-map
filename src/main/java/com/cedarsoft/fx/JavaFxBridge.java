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

/**
 * Factory to create a bridge between java and fx objects.
 * <p/>
 * Usage example:
 * <pre>
 * JavaFxBridge.bridge( javaCustomer ).to( fxCustomer ).connecting(
 *  JavaFxBridge.bind( &quot;name&quot; ).to( &quot;name&quot; ).withInverse().initialValue( javaCustomer.getName() ),
 *  JavaFxBridge.bind( &quot;address&quot; ).to( &quot;address&quot; ).withInverse(),
 *  JavaFxBridge.bind( &quot;mail&quot; ).to( &quot;mail&quot; ).
 *    usingConverter( new EmailConverter.Java2Fx() ).
 *    withInverse().usingConverter( new EmailConverter.Fx2Java() )
 * );
 * <p/>
 * </pre>
 */
public class JavaFxBridge {
  @NotNull
  public static FluentJavaObject bridge( @NotNull Object javaObject ) {
    return new FluentJavaObject( javaObject );
  }

  @NotNull
  @NonNls
  public static FluentJavaPropertySource bind( @NotNull @NonNls String propertyName ) {
    return new FluentJavaPropertySource( propertyName );
  }

  public static class FluentJavaObject {
    @NotNull
    private final Object javaObject;

    public FluentJavaObject( @NotNull Object javaObject ) {
      this.javaObject = javaObject;
    }

    @NotNull
    public FluentFxObject to( @NotNull FXObject fxObject ) {
      return new FluentFxObject( this, fxObject );
    }
  }

  public static class FluentFxObject {
    @NotNull
    private final FluentJavaObject fluentJavaObject;
    @NotNull
    private final FXObject fxObject;

    @NotNull
    private Java2FxStrategy java2FxStrategy = Java2FxStrategy.PROPERTY_CHANGE_EVENTS;
    @NotNull
    private Fx2JavaStrategy fx2JavaStrategy = Fx2JavaStrategy.SETTER;

    public FluentFxObject( @NotNull FluentJavaObject fluentJavaObject, @NotNull FXObject fxObject ) {
      this.fluentJavaObject = fluentJavaObject;
      this.fxObject = fxObject;
    }

    public void connecting( @NotNull PropertyBridgeStatement... statements ) throws NoSuchFieldException, IllegalAccessException {
      if ( statements.length == 0 ) {
        throw new IllegalArgumentException( "Need at least one bridging statement" );
      }

      //Java --> FX
      AbstractJava2Fx java2fxBridge = createJava2FxBridge();

      for ( PropertyBridgeStatement statement : statements ) {
        JavaProperty property = new JavaProperty( statement.propertyName );
        FXVar fxVar = new FXVar( fxObject.getClass(), statement.varName );

        if ( statement.initialValueSet ) {
          java2fxBridge.bind( property, fxVar, statement.java2FxConverter, statement.initialValue );
        } else {
          java2fxBridge.bind( property, fxVar, statement.java2FxConverter );
        }

        if ( statement.withInverse ) {
          getOrCreateFx2JavaBridge().bind( fxVar, property, statement.fx2javaConverter );
        }
      }
    }

    private AbstractJava2Fx createJava2FxBridge() throws NoSuchFieldException, IllegalAccessException {
      if ( java2FxBridge == null ) {
        java2FxBridge = java2FxStrategy.create( fluentJavaObject.javaObject, fxObject );
      }
      return java2FxBridge;
    }

    private AbstractJava2Fx java2FxBridge;
    private AbstractFX2Java fx2JavaBridge;

    /**
     * Return the fx to java bridge (or creates it if necessary)
     *
     * @return the fx to java bridge
     */
    @NotNull
    private AbstractFX2Java getOrCreateFx2JavaBridge() {
      if ( fx2JavaBridge == null ) {
        fx2JavaBridge = fx2JavaStrategy.create( fxObject, fluentJavaObject.javaObject );
      }
      return fx2JavaBridge;
    }

    /**
     * @noinspection ParameterHidesMemberVariable
     */
    @NotNull
    public FluentFxObject using( @NotNull Java2FxStrategy java2FxStrategy, @NotNull Fx2JavaStrategy fx2JavaStrategy ) {
      this.java2FxStrategy = java2FxStrategy;
      this.fx2JavaStrategy = fx2JavaStrategy;
      return this;
    }

    /**
     * @noinspection ParameterHidesMemberVariable
     */
    @NotNull
    public FluentFxObject using( @NotNull AbstractJava2Fx java2FxBridge, @NotNull AbstractFX2Java fx2JavaBridge ) {
      this.java2FxBridge = java2FxBridge;
      this.fx2JavaBridge = fx2JavaBridge;
      return this;
    }
  }

  public static class FluentJavaPropertySource {
    @NotNull
    @NonNls
    private final String propertyName;

    public FluentJavaPropertySource( @NotNull @NonNls String propertyName ) {
      this.propertyName = propertyName;
    }

    public PropertyBridgeStatement to( @NotNull @NonNls String varName ) {
      return new PropertyBridgeStatement( propertyName, varName );
    }
  }

  public static class PropertyBridgeStatement {
    @NotNull
    @NonNls
    private final String propertyName;
    @NotNull
    @NonNls
    private final String varName;

    private boolean withInverse;

    @Nullable
    private Converter<?, ?> java2FxConverter;
    @Nullable
    private Converter<?, ?> fx2javaConverter;
    @Nullable
    private Object initialValue;
    private boolean initialValueSet;

    public PropertyBridgeStatement( @NotNull String propertyName, @NotNull String varName ) {
      this.propertyName = propertyName;
      this.varName = varName;
    }

    @NotNull
    public PropertyBridgeStatement usingConverter( @NotNull Converter<?, ?> converter ) {
      if ( withInverse ) {
        if ( fx2javaConverter != null ) {
          throw new IllegalStateException( "There has still been set a fx2javaConverter: <" + java2FxConverter + ">" );
        }
        if ( java2FxConverter == null ) {
          throw new IllegalStateException( "No java2FxConverter has been set." );
        }
        fx2javaConverter = converter;
        return this;
      } else {
        if ( java2FxConverter != null ) {
          throw new IllegalStateException( "There has still been set a java2fxConverter: <" + java2FxConverter + ">" );
        }
        java2FxConverter = converter;
        return this;
      }
    }

    @NotNull
    public PropertyBridgeStatement withInverse() {
      withInverse = true;
      return this;
    }

    /**
     * @noinspection ParameterHidesMemberVariable
     */
    @NotNull
    public PropertyBridgeStatement initialValue( @Nullable Object initialValue ) {
      if ( initialValueSet ) {
        throw new IllegalStateException( "Initial value has still been set!" );
      }
      this.initialValue = initialValue;
      initialValueSet = true;
      return this;
    }
  }

}
