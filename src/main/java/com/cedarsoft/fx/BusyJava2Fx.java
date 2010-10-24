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

import javax.swing.Timer;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Map;

/**
 * This is a workaround! Do not use this class unitl you really know what you are doing!
 * <p/>
 * This bridge updates JavaFX objects whenever a java class has been updated. But be careful! This class polls
 * the java objects actively. This is a fallback class that may be useful for some corner cases. But generally
 * this is *not* the solution.
 * <p/>
 * Use {@link com.cedarsoft.fx.PropertyChangeEvent2Fx} instead!
 */
public class BusyJava2Fx extends AbstractJava2Fx {
  @NotNull
  private final Timer timer;

  public BusyJava2Fx( @NotNull Object bindee, @NotNull FXObject binder ) throws NoSuchFieldException, IllegalAccessException {
    this( bindee, binder, 20 );
  }

  public BusyJava2Fx( @NotNull Object bindee, @NotNull FXObject binder, final int delay ) throws NoSuchFieldException, IllegalAccessException {
    super( bindee, binder );

    updateVars();

    timer = new Timer( delay, new ActionListener() {
      @Override
      public void actionPerformed( ActionEvent e ) {
        try {
          updateVars();
        } catch ( Exception ex ) {
          throw new RuntimeException( ex );
        }
      }
    } );
    timer.setRepeats( true );
    timer.start();
  }

  private void updateVars() throws NoSuchFieldException, IllegalAccessException {
    for ( Map.Entry<JavaProperty, FXVar> entry : boundVars.entrySet() ) {
      JavaProperty property = entry.getKey();

      FXVar fxVar = entry.getValue();

      Object value = getValueByReflection( property );
      setVar( fxVar, value );
    }
  }

  @Override
  protected Object getInitialValue( @NotNull @NonNls JavaProperty property ) throws NoSuchFieldException, IllegalAccessException {
    return getValueByReflection( property );
  }

  public void stop() {
    timer.stop();
  }
}

