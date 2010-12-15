package se.pearglans.fx;
/*
 * Main.fx
 *
 * Created on 06.09.2009, 15:36:25
 */

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.text.Text;//?
import javafx.scene.text.Font;//?
import javafx.scene.shape.Ellipse;
import javafx.scene.paint.Color;
import javafx.scene.shape.Line;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Polyline;//?
import javafx.scene.shape.Circle;
import javafx.scene.effect.Glow;
import javafx.scene.effect.Lighting;
import javafx.scene.shape.Polygon;
import javafx.scene.paint.RadialGradient;//?
import javafx.scene.paint.Stop;
import javafx.scene.paint.LinearGradient;
import javafx.scene.transform.Rotate;
import javafx.scene.transform.Shear;//?
import javafx.scene.effect.MotionBlur;
import javafx.scene.effect.Reflection;
import javafx.scene.effect.SepiaTone;
import javafx.scene.transform.Scale;//?

/**
 * @author Philipp Lebedev
 */
Stage {
    title: "Application title"
    width: 640
    height: 480

    scene: Scene {
            fill: Color.BLACK
//Ð·Ð°Ñ‡ÐµÐ¼ ÑÑ‚Ð¾Ð»ÑŒÐºÐ¾ Ð¿ÑƒÑÑ‚Ñ‹Ñ… ÑÑ‚Ñ€Ð¾Ðº?


        content: [



            Line {
                    startX: 0, startY: 290
                    endX: 640, endY: 290
                    strokeWidth: 2
                    stroke: Color.DARKBLUE
            }
            Rectangle {


                    x: 0, y: 291
                    width: 640, height: 200
                    fill: LinearGradient {
                                    startX : 0.0
                                    startY : 0.0
                                    endX : 1.0
                                    endY : 0.0
                                    stops: [
                                            Stop {
                                                    color : Color.BISQUE
                                                    offset: 0.0
                                            },
                                            Stop {
                                                    color : Color.DARKBLUE
                                                    offset: 1.0
                                            },

                                    ]
                            }
            }




                        Ellipse {
                    centerX: 320, centerY: 300
                    radiusX: 180, radiusY: 40
                    fill: Color.GREEN
                    transforms: Rotate { pivotX : 0.0, pivotY : 0.0, angle: -1.0 }


                    effect: MotionBlur {
                                    angle: 45
                                    radius: 10
                            }


            }

            Polygon {
                    points : [ 320,100, 270,300, 360,300 ]
                    effect: Lighting {
                            diffuseConstant: 1.0
                            specularConstant: 1.0
                            specularExponent: 20
                            surfaceScale: 1.5
                    }


                    fill: LinearGradient {
                                    startX : 0.0
                                    startY : 0.0
                                    endX : 1.0
                                    endY : 0.0
                                    stops: [
                                            Stop {
                                                    color : Color.BISQUE
                                                    offset: 0.0
                                            },
                                            Stop {
                                                    color : Color.YELLOW
                                                    offset: 1.0
                                            },

                                    ]
                            }
                            }



            Rectangle {
                    x: 180, y: 270
                    width: 40, height: 25
                    fill: Color.ORANGE


            }
            Rectangle {
                    x: 187, y: 279
                    width: 8, height: 16
                    fill: Color.GREY
            }
            Rectangle {
                    x: 202, y: 278
                    width: 10, height: 10
                    fill: Color.BURLYWOOD




            }

            Rectangle {
                    x: 240, y: 300
                    width: 30, height: 25
                    fill: Color.ORANGE
            }
            Circle {
                    centerX: 252, centerY: 309
                    radius: 5
                    fill: Color.BURLYWOOD
            }

            Rectangle {
                    x: 300, y: 270
                    width: 40, height: 25
                    fill: Color.ORANGE
            }
            Rectangle {
                    x: 307, y: 279
                    width: 8, height: 16
                    fill: Color.GREY
            }
            Ellipse {
                    centerX: 327, centerY: 280
                    radiusX: 8, radiusY: 5
                    fill: Color.BURLYWOOD
            }




            Rectangle {
                    x: 370, y: 290
                    width: 40, height: 25
                    fill: Color.ORANGE
            }
            Rectangle {
                    x: 390, y: 299
                    width: 8, height: 16
                    fill: Color.GREY
            }
            Rectangle {
                    effect: Reflection {
                                    fraction: 0.75
                                    topOffset: 0.0
                                    topOpacity: 0.5
                                    bottomOpacity: 0.0
                            }


                    x: 375, y: 297
                    width: 10, height: 10
                    fill: Color.BURLYWOOD
            }

            Polygon {
                    points : [ 178,270, 200,255, 222,270 ]
                    fill: Color.RED
            }
            Polygon {
                    points : [ 238,300, 255,290, 272,300 ]
                    fill: Color.RED
            }
            Polygon {
                    points : [ 298,270, 320,257, 342,270 ]
                    fill: Color.RED
            }
            Polygon {
                    points : [ 366,290, 390,280, 414,290 ]
                    fill: Color.RED
            }





            Ellipse {
                    centerX: 320, centerY: 80
                    radiusX: 200, radiusY: 40
                    fill: Color.INDIGO
                    effect: Glow { level:2 }//ÐžÑˆÐ¸Ð±ÐºÐ°. Ð§Ð¸Ñ‚Ð°Ð¹Ñ‚Ðµ Ð´Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚Ð°Ñ†Ð¸ÑŽ. Opacity must be in the range [0,1]
                    transforms: Rotate { pivotX : 0.0, pivotY : 0.0, angle: 5.0 }

            }
            Ellipse {
                    centerX: 320, centerY: 75
                    radiusX: 100, radiusY: 15
                    fill: Color.INDIGO
                    effect: Glow { level:4 }//ÐžÑˆÐ¸Ð±ÐºÐ°. Ð§Ð¸Ñ‚Ð°Ð¹Ñ‚Ðµ Ð´Ð¾ÐºÑƒÐ¼ÐµÐ½Ñ‚Ð°Ñ†Ð¸ÑŽ. Opacity must be in the range [0,1]
                    transforms: Rotate { pivotX : 0.0, pivotY : 0.0, angle: 5.0 }
            }












        ]
    }
}