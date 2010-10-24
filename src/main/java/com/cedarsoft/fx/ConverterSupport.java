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

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.HashMap;
import java.util.Map;

/**
 * Helper class for converters
 *
 * @param <K> the key type
 */
public class ConverterSupport<K> {
  @NotNull
  private final Map<K, Converter<?, ?>> converters = new HashMap<K, Converter<?, ?>>();

  /**
   * Converts the given object if there is a converter registered for the key
   *
   * @param key   the key
   * @param value the object to convert (if there is a converter for the key)
   * @return the originally or converted object
   */
  @Nullable
  protected Object convertIfNecessary( @NotNull K key, @Nullable Object value ) {
    @Nullable Converter<?, ?> converter = converters.get( key );
    if ( converter == null ) {
      return value;
    }

    return ( ( Converter ) converter ).convert( value );
  }

  /**
   * Stores a converter.
   * If the converter is null, this method does nothing
   *
   * @param key       the key the converter is stored for
   * @param converter the converter
   */
  public void store( @NotNull K key, @Nullable Converter<?, ?> converter ) {
    if ( converter != null ) {
      converters.put( key, converter );
    }
  }
}
