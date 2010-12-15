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
import javafx.scene.shape.Line;
import javafx.scene.shape.MoveTo;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.KeyCode;
import javafx.scene.input.InputMethodEvent;
import javafx.scene.layout.Container;
import javafx.scene.effect.Effect;
import javafx.scene.effect.Glow;
import javafx.scene.effect.BlendMode;
import com.cedarsoft.fx.JavaFxBridge;
import com.sun.javafx.runtime.FXObject;


// Scala project ScalaFactorial

import se.pearglans.fx.JavaFXScalaBridge;
import se.pearglans.*;


/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-nov-11
 * Time: 19:42:45
 * To change this template use File | Settings | File Templates.
 */

public class LabelNode extends Group {

    override var blendMode =  BlendMode.MULTIPLY;

     package var parentConnector : NodeConnector = null;

     /*override var translateY = bind this.data.pos().y();*/
     package var data:MNode;

     //override var style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: blue;-fx-caret-color:white";

     var lblEffect : Effect = javafx.scene.effect.Identity {};
     var currentContent : Node = null;
     var lblStyle : String = "";
     var cfill: Color = Color.BLACK;

        override var onMouseDragged = function(me:MouseEvent) : Void {
            //StageBase.drawArea.removeNode(this)
        }

        override var onKeyPressed = function(e:KeyEvent) : Void {
            if(e.code == KeyCode.VK_F2) {
                this.setEditable(StageBase.drawArea);
            }
        }

     package function setNonEditable() : Void {
         if(this.currentContent != null) {
             var cont = this.currentContent;
             delete cont from content;
         }
         currentContent = Label {

             textFill: bind cfill
             effect: bind lblEffect
             styleClass: bind lblStyle with inverse            
             opacity: 1.0

         }
         JavaFxBridge.bridge( this.data ).to( currentContent as FXObject ).connecting(
           //JavaFxBridge.bind( "text" ).to( "text" )
           JavaFxBridge.bind( "text" ).to( "text" ).withInverse()
         );

         //label.bindit();
         insert currentContent into content;

     }
     package function setSelected(sele:Boolean) :Void {
         if(StageBase.selectedLbl != null and StageBase.selectedLbl != this) {
             StageBase.selectedLbl.setSelected(false);
         }
         if(sele) {
             cfill = Color.BLUE;
            lblEffect = null;
             //lblEffect = Glow { level : 0.9 }
             //currentContent.style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: blue;-fx-caret-color:white";
         } else {
            cfill = Color.BLACK;
            lblEffect = null; //Glow { level : 1 };
             //currentContent.style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: white;-fx-caret-color:white";

         }
         StageBase.selectedLbl = this;
     }

     package function remove(container:Group) : Void {
         delete this from container.content;
      }

    package function setEditable(container:Group) : Void {
        setEditable(container,null)
    }

     package function setEditable(container:Group,insertedAtNode:MNode) : Void {
         if(this.currentContent != null) {
             delete this.currentContent from this.content;
         }

         var textBox : TextBox = TextBox {
             columns: 25,
             text : data.text()
             //oopacity:0.5,
             //style: "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: red;-fx-caret-color:white"
             ,
             onKeyPressed : function(ev: KeyEvent) {
            
                 if(ev.code == KeyCode.VK_ENTER) {
                     var newText = textBox.text;
                     if(newText == "") {
                         remove(container);
                     } else {
                         data.text_$eq(newText);
                         setNonEditable();
                         StageBase.currentTextInput = null;
                         StageBase.fxScalaBridge.add(data, insertedAtNode);

                         this.setSelected(true);
                     }
                 }
             };

         }

         this.currentContent = textBox;
         insert this.currentContent into content;
         textBox.requestFocus();
     }

     package function bindit() : Void {

         JavaFxBridge.bridge( this.data.pos() ).to( this as FXObject ).connecting(
           //JavaFxBridge.bind( "text" ).to( "text" )
           JavaFxBridge.bind( "y" ).to( "translateY" ).withInverse(),
           JavaFxBridge.bind( "x" ).to( "translateX" ).withInverse()
         );
         /*JavaFxBridge.bridge( this.data.pos() ).to( this as FXObject ).connecting(

         );*/

         onMousePressed = function (ev: MouseEvent) : Void {
             StageBase.draggedNode = this;
             this.setSelected(true);
         }

         onMouseEntered = function (ev: MouseEvent) : Void {
            if(ev.controlDown and StageBase.draggedNode != this) {
                println("ooover");
                this.lblStyle="my-rect";
            }
         }
         onMouseExited = function (ev: MouseEvent) : Void {
            if(ev.controlDown and StageBase.draggedNode != this) {
                println("out");
                this.lblStyle="my-rect";
            }
         }

         onMouseReleased = function (ev: MouseEvent) : Void {
             if(StageBase.draggedNode != null) {
                 if(ev.controlDown) {
                    println("moving");
                     if(this == StageBase.draggedNode) {
                            
                     } else {
                            StageBase.drawArea.removeNode(StageBase.draggedNode);
                            StageBase.drawArea.populateTree(this.data,StageBase.draggedNode.data);
                            StageBase.draggedNode = null;                        
                     }
                 }
             }
         }

     };

     var texten:String = "";

     //function getData() : MNode;
     var getData : function() : MNode;
     postinit {
     
         /*var underStroke = Line {
            stroke: Color.RED;
            startX:bind LabelNode.this.boundsInLocal.minX,
            endX:bind LabelNode.this.boundsInLocal.maxX,
            startY:bind LabelNode.this.boundsInLocal.minY,
            endY:bind LabelNode.this.boundsInLocal.maxY,

        }
        insert underStroke into this.content;*/
     }
 };
