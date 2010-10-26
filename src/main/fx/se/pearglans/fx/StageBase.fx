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



// Scala project ScalaFactorial

import se.pearglans.fx.JavaFXScalaBridge;
import se.pearglans.*;

var stage: Stage;

def fxScalaBridge = JavaFXScalaBridge {
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
var selectedLbl : LabelNode = null;
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
        
        /*var circ = Circle {
                centerX: 75
                centerY: 85.98
                radius: 30
                fill: Color.BLUE
                opacity: 0.5

            }
        circ.onMouseDragged = function(ev: MouseEvent) {
                                        
            circ.centerX = ev.x;
            circ.centerY= ev.y;
        }
        insert circ into stage.scene.content*/

    }
}

import com.cedarsoft.fx.JavaFxBridge;
import com.sun.javafx.runtime.FXObject;

var draggedNode:Node = null;
class LabelNode extends Container {


    /*override var translateY = bind this.data.pos().y();*/
    var data:MNode;

    override var style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: white;-fx-caret-color:white";         

    var currentContent : Node = null;

    function setNonEditable() : Void {
        if(this.currentContent != null) {
            var cont = this.currentContent;
            delete cont from content;
        }
        var currentContent = Label {
            textFill: Color.BLACK,
        }
        JavaFxBridge.bridge( this.data ).to( currentContent as FXObject ).connecting(
          //JavaFxBridge.bind( "text" ).to( "text" )
          JavaFxBridge.bind( "text" ).to( "text" ).withInverse()
        );

        //label.bindit();
        insert currentContent into content;

    }

    function remove(container:Group) : Void {
        delete this from container.content;
     }


    function setEditable(container:Group) : Void {
        if(this.currentContent != null) {
            delete this.currentContent from content;
        }

        var textBox : TextBox = TextBox {
            columns: 25,                      
            opacity:0.5,
            style: "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: red;-fx-caret-color:white"
            ,
            onKeyPressed : function(ev: KeyEvent) {
                print("Yo");
                if(ev.code == KeyCode.VK_ENTER) {
                    var newText = textBox.text;
                    if(newText == "") {
                        remove(container);
                    } else {
                        print(newText);
                        data.text_$eq(newText);
                        setNonEditable();
                        currentTextInput = null;

                        fxScalaBridge.add(selectedNode, data);
                        /*if(selectedNode != null) {
                            var cubicCurve = CubicCurve {
                                //startX : bind selectedLbl.translateX startY : bind selectedLbl.translateY
                                controlX1 : bind 0.7 controlY1 : 0.7
                                controlX2 : bind 0.7 controlY2 : 0.7
                                endX : bind efx endY : bind efy
                            };
                            insert cubicCurve into drawArea.content;
                        } */

                        selectedLbl = this;
                    }
                }
            };
        }

        this.currentContent = textBox;
        print("Tja");
        insert this.currentContent into content;
        textBox.requestFocus();
    }

    function bindit() : Void {

        JavaFxBridge.bridge( this.data.pos() ).to( this as FXObject ).connecting(
          //JavaFxBridge.bind( "text" ).to( "text" )
          JavaFxBridge.bind( "x" ).to( "translateX" ).withInverse()
        );
        JavaFxBridge.bridge( this.data.pos() ).to( this as FXObject ).connecting(
          //JavaFxBridge.bind( "text" ).to( "text" )
          JavaFxBridge.bind( "y" ).to( "translateY" ).withInverse()
        );
        
        onMousePressed = function (ev: MouseEvent) : Void {
            draggedNode = this;
        }
        onMouseReleased = function (ev: MouseEvent) : Void {
            draggedNode = null;
        }
    };

    var texten:String = "";
    /*
    */
    //var text = bind this.data.text() on replace { print ("yo")};
    //override var translateX = bind xxx.x on replace { print ("yo")};



    //function getData() : MNode;
    var getData : function() : MNode;
};

def factLabel = Label {font: font text: "1"}

var path: Path;
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
                draggedNode.translateX = efx;
                draggedNode.translateY = efy;
            }
            //insert LineTo { x: efx, y: efy } into path.elements;
        }
}
var backGroundClip = Rectangle {
        width: 800,
        height: 400,
        x:0,
        y:0
}
var drawArea:Group = Group { content: [backGround], onMousePressed : function(ev: MouseEvent) {

        if(ev.source == backGround) {
        var efx = if (ev.x > 0) then ev.x else 0;
        var efy = if (ev.y > 0) then ev.y else 0;

        var node = new MNode(new Point2D(efx,efy),"");
        
        var label= LabelNode {            
            data: node
        }
        label.bindit();
        label.setEditable(drawArea);
        insert label into drawArea.content;
        }
    }
};

/*
if(currentTextInput != null) {
        delete currentTextInput from drawArea.content;
        currentTextInput = null;
    } else {

        currentTextInput.onKeyPressed = function(ev: KeyEvent) {
            if(ev.code == KeyCode.VK_ENTER) {
                var newText = currentTextInput.text;
                delete currentTextInput from drawArea.content;
                currentTextInput = null;

                var node = new MNode(new Point2D(efx,efy),newText);
                var label= LabelNode {
                    textFill: Color.BLACK,
                    data: node
                }
                label.bindit();
                insert label into drawArea.content;

                fxScalaBridge.add(selectedNode, node);
                if(selectedNode != null) {
                    var cubicCurve = CubicCurve {
                        //startX : bind selectedLbl.translateX startY : bind selectedLbl.translateY
                        controlX1 : bind 0.7 controlY1 : 0.7
                        controlX2 : bind 0.7 controlY2 : 0.7
                        endX : bind efx endY : bind efy
                    };
                    insert cubicCurve into drawArea.content;
                }

                selectedLbl = label;
            }
        };
        insert currentTextInput into drawArea.content;
        currentTextInput.requestFocus();
    }


 */
stage = Stage { title: "JavaFX / Scala : Factorials" visible: false // !!
    onClose: function() { fxScalaBridge.closeScala(); }
    scene: Scene {
        width: 800 
        height: 400
        content: {
            VBox { content:
                [
                HBox {spacing: 20 content: [factButton, factLabel]},
                drawArea
                ]
            }
        }
    }
}

                                                              


var currentTextInput : TextBox = null;

var selectedNode : MNode = null;

var labels : MNode[] = [];



//drawArea.
/*
drawArea.onMousePressed = function(ev: MouseEvent) {

    var efx = if (ev.x > 0) then ev.x else 0;
    var efy = if (ev.y > 0) then ev.y else 0;

    path = Path {
        stroke: Color.BLUE
        strokeWidth: 2
        elements: MoveTo { x: efx, y: efy }
    };
    insert path into drawArea.content;
};
drawArea.onMouseDragged = function(ev: MouseEvent) {
    println("{ev.x} : {ev.y}");
    var efx = if (ev.x > 0) then ev.x else 0;
    var efy = if (ev.y > 0) then ev.y else 0;

    insert LineTo { x: efx, y: efy } into path.elements;

} */

// Start JavaTaskBase
fxScalaBridge.start();
