/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER
 * Copyright 2009 Sun Microsystems, Inc. All rights reserved. Use is subject to license terms.
 *
 * This file is available and licensed under the following license:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright notice,
 *     this list of conditions and the following disclaimer in the documentation
 *     and/or other materials provided with the distribution.
 *
 *   * Neither the name of Sun Microsystems nor the names of its contributors
 *     may be used to endorse or promote products derived from this software
 *     without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Main.fx
 *
 * Created on 18.09.2008, 13:02:31
 */

package se.pearglans.fx;

import javafx.animation.*;
import javafx.stage.*;
import javafx.scene.*;
import javafx.scene.shape.*;
import javafx.scene.paint.*;
import javafx.scene.input.*;
import javafx.scene.layout.*;
import javafx.scene.control.*;
import java.lang.Math;

var mobile = __PROFILE__ == "mobile";
var tv = __PROFILE__ == "tv";

var fullWidth:Integer = bind
    if (mobile) {
        Screen.primary.visualBounds.width as Integer
    } else {
        600
    };

var h:Integer = bind
    if (mobile or tv) {
        Screen.primary.visualBounds.height as Integer
    } else {
        400
    };

def wp:Integer = if( mobile ) (fullWidth/2) else 140;
def w = fullWidth - wp - 3;
def vgap:Integer = 20;
def r = 10.0;

def maxV = 2.0;


function rnd(a: Number, b: Number) : Number {
    return a + Math.random() * (b - a);
}

var nCoords : Integer = 8;

/* Velocity of the control points */
var v : Number [] = for (i in [0..7][n | indexof n < nCoords]) {
    rnd(-maxV, maxV)}

/* New velocity of the control points */
var t : Number [] = for (i in [0..7][n | indexof n < nCoords]) {0.0}

/* Control points of cubic or quadratic curve */
var p : Number [] = for (i in [0..7][n | indexof n < nCoords]) {
        if (i mod 2 == 0) {
            rnd(r, w - r)
        } else {
            rnd(r, h - r)
        }
    }

def clip = Timeline {
    repeatCount: Timeline.INDEFINITE
    keyFrames:
        KeyFrame {
            time: 40ms
            action: function () : Void {
                /* Iterating through all the control points */
                for (i in [0..7][n | indexof n < nCoords]) {
                    var np = p[i] + v[i];
                    /* Changing velocity direction if there is a collision */
                    if (((i mod 2) == 0 and (np > w-r or np < r)) or
                        ((i mod 2) == 1 and (np > h-r or np < r))) {
                        v[i] = -v[i]
                    }
                    p[i] += v[i];
                }
            }
        }
}

var strokeColor: Color = Color.BLUE;

def strokeFld : CheckBox =
    CheckBox {
    width: wp
    selected:true
    onMouseClicked:function(e:MouseEvent) : Void {
        strokeColor = if(strokeFld.selected) Color.BLUE else null;
    }
};

var fillColor: Color = null;

def fillFld : CheckBox = CheckBox {
    width: wp
    onMouseClicked:function(e:MouseEvent) : Void {
        fillColor = if(fillFld.selected) Color.GREEN else null;
    }
};

var cpFillColor : Color;
var cpStrokeColor : Color;
var pathColor : Color;
def cpFld : CheckBox = CheckBox {
    width: wp
    onMouseClicked:function(e:MouseEvent) : Void {
        if (cpFld.selected) {
            cpFillColor = Color.MAROON;
            cpStrokeColor = Color.web("0x808000");
            pathColor = Color.web("0xff6688",0.5);
        } else {
            cpFillColor = cpStrokeColor = pathColor = null;
        }
    }
};

def strokeWidth = Slider {
    min: 1
    max: 20
    width:wp
    height:20
}
var strokeDashGroupValue: Number [] = null;
var strokeDashGroup = ToggleGroup{};

def strokeDashFld = VBox {
    width: wp
    content:[
        HBox {
            content: [
                RadioButton {
                    toggleGroup: strokeDashGroup
                    selected: true
                    onMouseClicked:function(e:MouseEvent) : Void {
                        strokeDashGroupValue = null;
                    }
                },
                Label {
                    text: "null"
                    textFill: Color.ALICEBLUE
                }
        ]},
        HBox {
            content: [
                RadioButton {
                    toggleGroup: strokeDashGroup
                    onMouseClicked:function(e:MouseEvent) : Void {
                        strokeDashGroupValue = [8, 4];
                    }
                },
                Label {
                    text: "[8, 4]"
                    textFill: Color.ALICEBLUE
                }
        ]},
        HBox {
            content: [
                RadioButton {
                    toggleGroup: strokeDashGroup
                    onMouseClicked:function(e:MouseEvent) : Void {
                        strokeDashGroupValue = [32, 16];
                    }
                },
                Label {
                    text: "[32, 16]"
                    textFill: Color.ALICEBLUE
                }

        ]}
        HBox {
            content: [
                RadioButton {
                    toggleGroup: strokeDashGroup
                    onMouseClicked:function(e:MouseEvent) : Void {
                        strokeDashGroupValue = [64, 64];
                    }
                },
                Label {
                    text: "[64, 64]"
                    textFill: Color.ALICEBLUE
                }

        ]}
    ]
}

var strokeLineCapGroup = ToggleGroup{};
var strokeLineCapGroupValue = StrokeLineCap.BUTT;

def strokeLineCapFld = VBox {
    width:wp
    content:[
        HBox {
            content: [
                RadioButton {
                    toggleGroup: strokeLineCapGroup
                    selected: true
                    onMouseClicked:function(e:MouseEvent) : Void {
                        strokeLineCapGroupValue = StrokeLineCap.BUTT;
                    }
                },
                Label {
                    text: "BUTT"
                    textFill: Color.ALICEBLUE
                }
        ]},
        HBox {
            content: [
                RadioButton {
                    toggleGroup: strokeLineCapGroup
                    onMouseClicked:function(e:MouseEvent) : Void {
                        strokeLineCapGroupValue = StrokeLineCap.ROUND;
                    }
                },
                Label {
                    text: "ROUND"
                    textFill: Color.ALICEBLUE
                }
        ]},
        HBox {
            content: [
                RadioButton {
                    toggleGroup: strokeLineCapGroup
                    onMouseClicked:function(e:MouseEvent) : Void {
                        strokeLineCapGroupValue = StrokeLineCap.SQUARE;
                    }
                },
                Label {
                    text: "SQUARE"
                    textFill: Color.ALICEBLUE
                }
         ]}
    ]
}

var curveGroup = ToggleGroup{};
var cubicCurve = CubicCurve {
        startX : bind p[0] startY : bind p[1]
        controlX1 : bind p[2] controlY1 : bind p[3]
        controlX2 : bind p[4] controlY2 : bind p[5]
        endX : bind p[6] endY : bind p[7]
        stroke: bind strokeColor fill: bind fillColor
        strokeWidth: bind strokeWidth.value
        strokeDashArray: bind strokeDashGroupValue
        strokeLineCap: bind strokeLineCapGroupValue
    };

var quadCurve = QuadCurve {
        startX : bind p[0] startY : bind p[1]
        controlX : bind p[2] controlY : bind p[3]
        endX : bind p[4] endY : bind p[5]
        stroke: bind strokeColor fill: bind fillColor
        strokeWidth: bind strokeWidth.value
        strokeDashArray: bind strokeDashGroupValue
        strokeLineCap: bind strokeLineCapGroupValue
    };


var curveGroupValue:Shape = cubicCurve;

def curveFld = VBox {
    width:wp
    content: [
        HBox {
            content: [
                RadioButton {
                    toggleGroup: curveGroup
                    selected: true
                    onMouseClicked:function(e:MouseEvent) : Void {
                        curveGroupValue = cubicCurve;
                    }
                },
                Label {
                    text: "CubicCurve"
                    textFill: Color.ALICEBLUE
                }
        ]},
        HBox {
            content: [
            RadioButton {
                toggleGroup: curveGroup
                onMouseClicked:function(e:MouseEvent) : Void {
                    curveGroupValue = quadCurve;
                }
            },
            Label {
                text: "QuadCurve"
                textFill: Color.ALICEBLUE
            }
        ]}
    ]

}

var geomArea : Group = Group {}

var curve : Shape = bind curveGroupValue as Shape on replace {
    if (curve instanceof CubicCurve) {
        nCoords = 8;
    } else {
        nCoords = 6;
    }

    geomArea.content = [
        curve,
        for (i in [0, 2, 4, 6][n | n < nCoords])
        Ellipse {
            centerX: bind p[i]
            centerY: bind p[i + 1]
            radiusX:r radiusY:r
            stroke: bind cpStrokeColor fill: bind cpFillColor
            strokeWidth: 2
            onMouseDragged: function(e:MouseEvent) : Void {
                t[i] += e.dragX/50;
                t[i+1] += e.dragY/50;
                p[i] = if (e.sceneX < r) r else {
                    if (e.sceneX > w-r) w-r else e.sceneX
                }
                p[i+1] = if (e.sceneY < r) r else {
                    if (e.sceneY > h-r) h-r  else e.sceneY
                }

                if (t[i] > maxV) t[i] = maxV;
                if (t[i] < -maxV) t[i] = -maxV;
                if (t[i+1] > maxV) t[i+1] = maxV;
                if (t[i+1] < -maxV) t[i+1] = -maxV;
            }
            onMousePressed: function(e:MouseEvent) : Void {
                t[i] = v[i]; t[i+1] = v[i+1];
                v[i] = 0; v[i+1] = 0;
            }
            onMouseReleased: function(e:MouseEvent) : Void {
                v[i] = t[i]; v[i+1] = t[i+1];
            }
            onMouseClicked: function(e:MouseEvent) : Void {
                v[i] = 0; v[i+1] = 0;
            }
        },
        Path {
            stroke: bind pathColor
            strokeWidth: 2
            fill:null
            elements: [
                MoveTo {
                    x: bind p[0] y: bind p[1]
                },
                for (i in [2, 4, 6][n | n < nCoords]) {
                    LineTo {
                        x: bind p[i] y: bind p[i+1]
                    }
                }
            ]
        }
    ]
}

var stage: Stage = Stage {
    title: "Bezier";
    visible: true
    resizable: false
    scene: Scene {
        fill: Color.BLACK
        content:[
            Group {
                content: [
                    Rectangle {
                        width: w height:h
                        fill: null
                        stroke: Color.WHITE
                    },
                    geomArea,
                    VBox {
                        layoutX: w + 3
                        width: wp
                        height: h

                        content: [
                            curveFld,
                            Label {height: vgap},
                            HBox {
                                content: [
                                    strokeFld,
                                    Label {
                                        text: "Stroke"
                                        textFill: Color.ALICEBLUE
                            }]},
                            HBox {
                                content: [
                                    fillFld,
                                    Label {
                                        text: "Fill"
                                        textFill: Color.ALICEBLUE
                            }]},
                            HBox {
                                content: [
                                    cpFld,
                                    Label {
                                        text: "Control Points"
                                        textFill: Color.ALICEBLUE
                            }]},

                            Label {height: vgap},
                            Label {
                                width: wp
                                text:  bind " Stroke Width {strokeWidth.value}"
                                textFill: Color.ALICEBLUE
                            },
                            strokeWidth,
                            Label {height: vgap},
                            Label {
                                width: wp
                                text: " Stroke Dash Array"
                                textFill: Color.ALICEBLUE
                            },
                            strokeDashFld,
                            Label {height: vgap},
                            Label {
                                width: wp
                                text: " Stroke Line Cap"
                                textFill: Color.ALICEBLUE
                            },
                            strokeLineCapFld
                        ]
                    }
                ]
            }
        ]
    }
}

strokeWidth.value = 3;
cpFld.selected = true;
cpFld.onMouseClicked(null);
clip.play();