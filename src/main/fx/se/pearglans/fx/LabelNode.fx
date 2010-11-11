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

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-nov-11
 * Time: 19:42:45
 * To change this template use File | Settings | File Templates.
 */

public class LabelNode extends Group {


     /*override var translateY = bind this.data.pos().y();*/
     package var data:MNode;

     override var style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: blue;-fx-caret-color:white";

     var currentContent : Node = null;

     var cfill: Color = Color.TRANSPARENT;

     package function setNonEditable() : Void {
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
     package function setSelected(sele:Boolean) :Void {
         if(StageBase.selectedLbl != null and StageBase.selectedLbl != this) {
             StageBase.selectedLbl.setSelected(false);
         }
         if(sele) {
             cfill = Color.GREEN;
             currentContent.style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: green;-fx-caret-color:white";
         } else {
            cfill = Color.BLACK;
             currentContent.style = "-fx-font: 25pt ""Impact, Helvetica"";-fx-font-style: regular;-fx-text-fill: black; -fx-border-color: white;-fx-border-width: 1;-fx-background-color: white;-fx-caret-color:white";

         }
         StageBase.selectedLbl = this;
     }

     package function remove(container:Group) : Void {
         delete this from container.content;
      }


     package function setEditable(container:Group) : Void {
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
                         StageBase.currentTextInput = null;

                         StageBase.fxScalaBridge.add(StageBase.selectedNode, data);

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

         onMouseReleased = function (ev: MouseEvent) : Void {
             StageBase.draggedNode = null;
         }
     };

     var texten:String = "";

     //function getData() : MNode;
     var getData : function() : MNode;
 };
