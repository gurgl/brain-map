package se.pearglans.fx;

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-okt-04
 * Time: 13:04:13
 * To change this template use File | Settings | File Templates.
 */

import javafx.scene.control.TextBox;

import javafx.scene.Scene;
import javafx.scene.Node;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.scene.layout.Stack;
import javafx.scene.Group;
import javafx.scene.text.Font;
import javafx.stage.Stage;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.scene.shape.Path;
import javafx.scene.shape.CubicCurve;
import javafx.scene.shape.LineTo;
import javafx.scene.shape.MoveTo;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.Container;


import com.cedarsoft.fx.JavaFxBridge;
import com.sun.javafx.runtime.FXObject;


// Scala project ScalaFactorial

import se.pearglans.fx.JavaFXScalaBridge;
import se.pearglans.*;

import LabelNode;


package var stage: Stage;

package def fxScalaBridge = JavaFXScalaBridge {
    initJavaFX: function(s: ScalaEntry): Void {
        // Show frame
        stage.visible = true;
    };
    updateTreeNode: function(node: MNode): Void {
        //sync(node,labels)
    };
    // Called from Scala
    updateFactText: function(text: String): Void {
        factLabel.text = text;
    }
}

def font = Font {size: 24}
public var selectedLbl : LabelNode = null;

def factButton: Button = Button { font: font text: " 1 ! "
    var n = 1
    action: function() {
        n++;
        var f = (selectedLbl.data.pos().x()) + 10.0;
        print(selectedLbl);
        print("---");
        selectedLbl.data.pos().setX(f);
        selectedLbl.data.pos().setY(f);
        fxScalaBridge.calcFactorial(n);
        factButton.text = " {n} ! ";
    }
}

def model:MNode = fxScalaBridge.getModel();

package var draggedNode:Node;

def factLabel = Label {font: font text: "1"}

package var path: Path;

var backGround = Rectangle {
        width: 800,
        height: 400,
        x:0,
        y:0,
        fill: Color.WHITE,
        onMouseDragged : function (ev: MouseEvent) : Void {
            //println("{ev.x} : {ev.y}");
            if(draggedNode != null) {
                var efx = if (ev.x > 0) then ev.x else 0;
                var efy = if (ev.y > 0) then ev.y else 0;
                //draggedNode.translateX = efx;
                var t = draggedNode as LabelNode;
                t.data.pos().setX(efx);
                t.data.pos().setY(efy);
                //draggedNode.translateY = efy;
            }
            //insert LineTo { x: efx, y: efy } into path.elements;
        }
}
var backGroundClip = Rectangle {
        width: 800,
        height: 400,
        x:0,
        y:0,
        fill:Color.TRANSPARENT
        translateZ:2,

}


package var drawArea = NodeContainer { content: [backGround] };


package var currentTextInput : TextBox;

package public-read var selectedNode : MNode;

var labels : MNode[] = [];


function run() {

    drawArea.populateTree(null,model);

    stage = Stage {
        title: "JavaFX / Scala : Factorials"
        visible: false // !!
        onClose: function() { fxScalaBridge.closeScala(); }
        scene: Scene {
            width: 800
            height: 400
            content: {
                Group {
                    content: [
                        VBox { content:
                            [
                            HBox {spacing: 20 content: [factButton, factLabel]},
                                drawArea
                            ]
                            },
                            Rectangle {
                                x:0
                                y:0
                                width:bind stage.width
                                height:bind stage.height
                                fill:Color.TRANSPARENT
                                opacity:0.5
                                translateZ:-10
                                //focusTraversable:true,
                        }],
                        focusTraversable:true,

                    onKeyPressed: function(ev: KeyEvent) { //onKeyPressed
                        print("Yo2 {ev.code}");
                        if(ev.code == KeyCode.VK_I) {
                            print("Insert");
                            if(selectedLbl != null) {
                                print("Insert2");
                                var bounds = selectedLbl.boundsInParent;
                                var mnode = new MNode(new Point2D(bounds.maxX,bounds.minY),"");
                                /*var label= LabelNode {
                                    data: mnode
                                }
                                label.bindit();

                                insert label into drawArea.content;*/
                                var parent = selectedLbl.data;

                                var label = drawArea.insertNode(parent, mnode);
                                label.setEditable(drawArea);
                            } else {

                            }
                        }
                    };
                }
            }
        }
    }


    drawArea.requestFocus();

    fxScalaBridge.start();
    
}

