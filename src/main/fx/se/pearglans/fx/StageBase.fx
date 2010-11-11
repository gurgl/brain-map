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



def model:MNode = fxScalaBridge.getModel();

var draggedNode:Node = null;
class LabelNode extends Group {


    /*override var translateY = bind this.data.pos().y();*/
    var data:MNode;

    override var style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: blue;-fx-caret-color:white";         

    var currentContent : Node = null;

    var cfill: Color = Color.TRANSPARENT;

    function setNonEditable() : Void {
        if(this.currentContent != null) {
            var cont = this.currentContent;
            delete cont from content;
        }
        var currentContent = Label {
            textFill: bind cfill

        }
        JavaFxBridge.bridge( this.data ).to( currentContent as FXObject ).connecting(
          //JavaFxBridge.bind( "text" ).to( "text" )
          JavaFxBridge.bind( "text" ).to( "text" ).withInverse()
        );

        //label.bindit();
        insert currentContent into content;

    }
    function setSelected(sele:Boolean) :Void {
        if(selectedLbl != null and selectedLbl != this) {
            selectedLbl.setSelected(false);            
        }
        if(sele) {
            cfill = Color.GREEN;
            currentContent.style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: green;-fx-caret-color:white";
        } else {
           cfill = Color.BLACK;
            currentContent.style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: white;-fx-caret-color:white";

        }
        selectedLbl = this;
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

                        this.setSelected(true);
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
          JavaFxBridge.bind( "y" ).to( "translateY" ).withInverse(),
          JavaFxBridge.bind( "x" ).to( "translateX" ).withInverse()
        );
        /*JavaFxBridge.bridge( this.data.pos() ).to( this as FXObject ).connecting(

        );*/
        
        onMousePressed = function (ev: MouseEvent) : Void {
            draggedNode = this;
            this.setSelected(true);
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

class MyCubicCurve extends CubicCurve {

    /*var dsx:Number;
    var dex:Number;
    var dsy:Number;
    var dey:Number;
    */
    public var dstartX:Number = 0; //bind dsx on replace { println("ooooiii") };
    public var dendX:Number = 0; //bind dex;
    public var dstartY:Number = 0; //bind dsy;
    public var dendY:Number = 0; //bind dey; //on invalidate { println ("ooooiii")};

    override def startX = bind this.dstartX; //{ java.lang.Math.cos(_startX - _endY ) * 20 + _startX };
    override def startY = bind this.dstartY;
    override def endY = bind this.dendY;
    override def endX = bind this.dendX;
    //                                                           sx
    //100 - (100 - 50)/2 =                                          ex
    //0 - (0 - 100) /2
    function calcX(Xstart:Number,Xend:Number,Ystart:Number,Yend:Number) : Number {
        var p1 = new Point2D(Xstart,Ystart);
        var p2 = new Point2D(Xend,Yend);

        (p1.x() ) - ((p1.x() - p2.x())/2 )      
    }

    function calcY(Xstart:Number,Xend:Number,Ystart:Number,Yend:Number) : Number {
        var p = new Point2D(Xstart,Ystart);

        //start - (start - end)/2
        10
    }

    override var controlX1 = bind calcX(this.dstartX,this.dendX,this.dstartY,this.dendY); // + (this.dstartX - this.dendX)/2;
    override var controlX2 = bind calcY(this.dstartX,this.dendX,this.dstartY,this.dendY); //this.dstartX + (this.dstartX - this.dendX)/2;

    override var controlY1 = bind calcX(this.dstartY,this.dendY, this.dstartY,this.dendY); //this.dstartY + (this.dstartY + this.dendY)/2;
    override var controlY2 = bind calcY(this.dstartY,this.dendY, this.dstartY,this.dendY); //this.dstartY + (this.dstartY + this.dendY)/2;
    

    var parentNode:LabelNode = null;
    var childNode:LabelNode = null;

    
    postinit {

        JavaFxBridge.bridge( parentNode.data.pos() ).to( this as FXObject ).connecting(
          JavaFxBridge.bind( "x").to("dstartX")
        );
        JavaFxBridge.bridge( parentNode.data.pos() ).to( this  as FXObject ).connecting(
          JavaFxBridge.bind( "y").to( "dstartY" )
        );
        JavaFxBridge.bridge( childNode.data.pos() ).to( this  as FXObject ).connecting(
          JavaFxBridge.bind( "x").to( "dendX" ).withInverse()
        );
        JavaFxBridge.bridge( childNode.data.pos() ).to( this  as FXObject ).connecting(
          JavaFxBridge.bind( "y").to( "dendY" )
        );

        
    }
}

class NodeContainer extends Group {


    function populateTree(parent:MNode, node:MNode) : Void {
        var label = insertNode(parent, node);
        label.setSelected(true);
        print("innan Node");
        print(node);
        var children = node.getChildren();
        for(l in children) {
        //for(l in [0..children.length-1]) {
            var n = l as MNode;
            populateTree(node, n)
        }
    }


    function insertNode(parent:MNode, node:MNode) : LabelNode {
        var label = LabelNode {
            data: node
        }
        label.bindit();
        label.setNonEditable();
        insert label into drawArea.content;

        var parentLbl:LabelNode = null;
        for(obj in drawArea.content) {
            if(obj instanceof LabelNode) {
                var ln = obj as LabelNode;
                if(ln.data == parent) {
                    parentLbl = ln;
                }
            }
        }
        if(parentLbl != null) {

            var apa:Number = 0;
            var cubicCurve = MyCubicCurve {
                fill: Color.TRANSPARENT,
                stroke: Color.RED,
                parentNode: parentLbl,
                childNode:label
            };

            insert cubicCurve into drawArea.content;
        }
        return label;
    }
}

var drawArea = NodeContainer { content: [backGround],
            


    /*onMousePressed : function(ev: MouseEvent) {

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
    },*/
    

};



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

var currentTextInput : TextBox = null;

var selectedNode : MNode = null;

var labels : MNode[] = [];

drawArea.requestFocus();

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
