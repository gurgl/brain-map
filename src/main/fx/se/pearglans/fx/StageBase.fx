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
import javafx.scene.input.InputMethodEvent;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.Container;


import com.cedarsoft.fx.JavaFxBridge;
import com.sun.javafx.runtime.FXObject;


// Scala project ScalaFactorial

import se.pearglans.fx.JavaFXScalaBridge;
import se.pearglans.*;
import se.pearglans.Tjo;

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
        //factLabel.text = text;
    }
}

def font = Font {size: 24}
public var selectedLbl : LabelNode = null;

def factButton: Button = Button { font: font text: " 1 ! "
    var n = 1
    action: function() {
        n++;
        var f = (selectedLbl.data.pos().x()) + 10.0;
        //print(selectedLbl);
        //print("---");
        selectedLbl.data.pos().setX(f);
        selectedLbl.data.pos().setY(f);
        fxScalaBridge.calcFactorial(n);
        factButton.text = " {n} ! ";
    }
}

def modelToLoad:MNode = Tjo.loadExampleModel();

package var draggedNode:LabelNode;




var backGround:Rectangle = Rectangle {
        width: 800,
        height: 400,
        x:0,
        y:0,
        opacity:1.0
        fill: Color.WHITE,
        ,
        onMouseDragged : function (ev: MouseEvent) : Void {
            //println("{ev.x} : {ev.y}");

            /*if(draggedNode != null) {

            }*/
            if(draggedNode == null ) {
                if(ev.source.equals(backGround)) {
                    drawArea.scrollTo(new Point2D(ev.sceneX - ev.dragAnchorX,ev.sceneY - ev.dragAnchorY),stage);
                    println("E {ev.x} {ev.y} {ev.source} {ev.node}");
                    println("D {ev.dragAnchorX} {ev.dragAnchorY} ");
                    println("T {StageBase.drawArea.translateX} {StageBase.drawArea.translateY}");
                }
            } else {
                var efx = if (ev.x > 0) then ev.x else 0;
                var efy = if (ev.y > 0) then ev.y else 0;
                //draggedNode.translateX = efx;
                var t = draggedNode as LabelNode;
                t.data.pos().setX(efx);
                t.data.pos().setY(efy);

            }
            //insert LineTo { x: efx, y: efy } into path.elements;
        }
}

package var drawArea:NodeContainer = NodeContainer {  content: [backGround] };


package var currentTextInput : TextBox;

package var selectedNode : MNode;

var labels : MNode[] = [];

var menuArea = HBox {spacing: 20 content: []}
var sceneContent:Group = Group {
    content: [
        VBox { content:
            [
                menuArea,
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

    var filter = "" on replace
      {
        var s = Tjo.findByName(filter);
        if(s != null) {
            var n = drawArea.findNodeByModel(s);
            if(n != null) {
                n.setSelected(true);
                drawArea.scrollToNodeAnimated(n,stage)
            }
            filter = s.text();
        } else {
            
        }

      }
    onKeyPressed: function(ev: KeyEvent) { //onKeyPressed
        //print("Yo2 {ev.code}");
        if(ev.code == KeyCode.VK_F and ev.controlDown) {
            var searchLbl = Label {text:"find"}
            var searchBox:TextBox = TextBox {
                focusTraversable:true,
                columns: 25,
                text : bind filter with inverse;
                onKeyPressed: function(ev: KeyEvent) {
                    if(ev.code == KeyCode.VK_ENTER) {
                        delete searchLbl from menuArea.content;
                        delete searchBox from menuArea.content;
                    }
                },       

                //style: "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: white;-fx-caret-color:white"
                ,
            };

            var dummy = bind searchBox.focused on replace {
                if(not searchBox.focused) {
                    delete searchLbl from menuArea.content;
                    delete searchBox from menuArea.content;
                }
            };
            insert searchLbl into menuArea.content;
            insert searchBox into menuArea.content;

            searchBox.requestFocus();
        } else if(ev.code == KeyCode.VK_DELETE) {
            if(selectedLbl != null) {
                var node= drawArea.removeNode(selectedLbl);
                node.setSelected(true);
            }
        } else if(ev.code == KeyCode.VK_F2) {
            if(selectedLbl != null) {
                selectedLbl.setEditable(drawArea);
            }
        } else if(ev.code == KeyCode.VK_I) {
            //Tjo.remove(selectedLbl.data);



            print("Insert");
            if(selectedLbl != null) {
                print("Insert2");

                var bounds = selectedLbl.boundsInParent;
                var mnode = new MNode(new Point2D(bounds.maxX + 20,bounds.minY),"");

                var parent = selectedLbl.data;
                println("parent  {parent}");
                var label = drawArea.insertNode(parent, mnode);

                var bla = function() : Void {
                    label.setEditable(drawArea, parent);
                };


                javafx.lang.FX.deferAction(bla);

            } else {

            }
        } else if(ev.code == KeyCode.VK_LEFT or ev.code == KeyCode.VK_RIGHT or
            ev.code == KeyCode.VK_DOWN or ev.code == KeyCode.VK_UP) {

            if(ev.controlDown and ev.shiftDown) {
                var dir = drawArea.getDirection(ev.code);
                if(selectedLbl != null) {
                    drawArea.scrollToNodeInDirection(selectedLbl,dir,stage);
                }
            } else if(ev.controlDown) {
                var dir = drawArea.getDirection(ev.code);
                if(selectedLbl != null) {
                    NodeHelper.translate(dir,selectedLbl.data)
                }
            } else {
                if(selectedLbl != null) {
                var dir = drawArea.getDirection(ev.code);

                    var nearest = drawArea.findNearest(dir,selectedLbl);
                    if(nearest != null) {
                        nearest.setSelected(true);
                    }
                }
            }
        }
    };
};

function run() {
    println("ConditionalFeature.INPUT_METHOD {javafx.runtime.Platform.isSupported(javafx.runtime.ConditionalFeature.INPUT_METHOD)}");
    drawArea.populateTree(null,modelToLoad);

    stage = Stage {
        title: "Brain Map"
        visible: false // !!
        opacity:0.5
        width:800
        height:400

        onClose: function() { fxScalaBridge.closeScala(); }
        scene: Scene {
            width: stage.width
            height: stage.height
            fill: Color.GRAY,
            stylesheets: [ "{__DIR__}/test.css" ]               
            content: {
                sceneContent
            }
        }
    }

    sceneContent.requestFocus();

    fxScalaBridge.start();    
}

