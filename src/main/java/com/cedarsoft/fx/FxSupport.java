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

/**
 * Support methods for JavaFX
 */
public class FxSupport {
  @NotNull
  @NonNls
  public static final String VOFF_FIELD_PREFIX = "VOFF$";

  private FxSupport() {
  }

  /**
   * Ensures that a var exists of the given type
   *
   * @param type    the type
   * @param varName the var name
   * @throws IllegalArgumentException if the var does not exist
   */
  public static void ensureVarExists( @NotNull Class<? extends FXObject> type, @NotNull @NonNls String varName ) throws NoSuchFieldException {
    type.getField( getVarFieldName( varName ) );
  }

  /**
   * Returns the var number for the given type
   *
   * @param type    the type
   * @param varName the var name
   * @return the number representing the var
   */
  public static int getVarNum( @NotNull Class<? extends FXObject> type, @NotNull @NonNls String varName ) throws NoSuchFieldException, IllegalAccessException {
    return ( Integer ) type.getField( getVoffFieldName( varName ) ).get( null );
  }

  /**
   * Returns the VOFF field name (containing the id of the var)
   *
   * @param varName the name of the var
   * @return the field name of the VOFF field
   */
  @NotNull
  @NonNls
  public static String getVoffFieldName( @NotNull @NonNls String varName ) {
    return VOFF_FIELD_PREFIX + varName;
  }

  /**
   * Returns the field name for a var ("$varName")
   *
   * @param varName the var name
   * @return the field name for a var
   */
  @NotNull
  @NonNls
  public static String getVarFieldName( @NotNull @NonNls String varName ) {
    return "$" + varName;
  }
}
