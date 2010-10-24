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
 * Represents informations about a var of an FXObject
 */
public class FXVar {
  @NotNull
  @NonNls
  private final String varName;
  private final int varNumField;

  /**
   * Creates a new FxVar. This method automatically looks up the varNumField using reflection
   *
   * @param type    the fx type
   * @param varName the var name
   * @throws NoSuchFieldException
   * @throws IllegalAccessException
   */
  public FXVar( @NotNull Class<? extends FXObject> type, @NotNull @NonNls String varName ) throws NoSuchFieldException, IllegalAccessException {
    this( varName, FxSupport.getVarNum( type, varName ) );
  }

  /**
   * Creates a new FXvar
   *
   * @param varName     the var name
   * @param varNumField the var num field
   */
  public FXVar( @NotNull String varName, int varNumField ) {
    this.varName = varName;
    this.varNumField = varNumField;
  }

  /**
   * Returns the var name
   *
   * @return the var name
   */
  @NotNull
  @NonNls
  public String getVarName() {
    return varName;
  }

  /**
   * Returns the var num field
   *
   * @return the var num field
   */
  public int getVarNumField() {
    return varNumField;
  }

  @Override
  public String toString() {
    return "FXVar{" +
      "'" + varName + '\'' +
      ", varNumField=" + varNumField +
      '}';
  }
}
