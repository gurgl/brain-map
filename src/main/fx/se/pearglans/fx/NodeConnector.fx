package se.pearglans.fx;

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
import javafx.scene.effect.DropShadow;

import com.cedarsoft.fx.JavaFxBridge;
import com.sun.javafx.runtime.FXObject;


// Scala project ScalaFactorial

import se.pearglans.fx.JavaFXScalaBridge;
//import se.pearglans.fx.LabelNode;
import se.pearglans.*;

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-nov-11
 * Time: 19:26:42
 * To change this template use File | Settings | File Templates.
 */
package class NodeConnector extends CubicCurve {

    override def stroke = Color.RED;

    /*var dsx:Number;
    var dex:Number;
    var dsy:Number;
    var dey:Number;
    */
    public var dstartX:Number = 0; //bind dsx on replace { println("ooooiii") };
    public var dendX:Number = 0; //bind dex;
    public var dstartY:Number = 0; //bind dsy;
    public var dendY:Number = 0; //bind dey; //on invalidate { println ("ooooiii")};

    var _startY = bind (this.dstartY + this.parentNode.boundsInLocal.maxY);
    var _startX = bind (if (this.dstartX > this.dendX) this.dstartX else this.dstartX + this.parentNode.boundsInLocal.maxX);
    var _endY = bind (this.dendY + this.childNode.boundsInLocal.maxY);
    var _endX = bind (if (this.dstartX < this.dendX) this.dendX else this.dendX + this.childNode.boundsInLocal.maxX);
    
    override var startX = bind this._startX; //{ java.lang.Math.cos(_startX - _endY ) * 20 + _startX };
    override var startY = bind this._startY;
    override var endX = bind this._endX;
    override var endY = bind this._endY;

    //                                                           sx
    //100 - (100 - 50)/2 =                                          ex
    //0 - (0 - 100) /2
    function calcX(Xstart:Number,Ystart:Number,Xend:Number, Yend:Number) : Number {
        var p1 = new Point2D(Xstart,Ystart);
        var p2 = new Point2D(Xend,Yend);

        (p1.x() ) - ((p1.x() - p2.x())/4 )
    }

    function calcY(Xstart:Number,Ystart:Number,Xend:Number, Yend:Number) : Number {
        var p1 = new Point2D(Xstart,Ystart);
        var p2 = new Point2D(Xend,Yend);
        
        (p1.y() ) - ((p1.y() - p2.y())/4 )*0.3
    }


    override var controlX1 = bind calcX(this._startX,this._startY,this._endX,this._endY); // + (this.dstartX - this.dendX)/2;
    override var controlX2 = bind calcX(this._endX,this._endY,this._startX,this._startY); //this.dstartX + (this.dstartX - this.dendX)/2;

    override def controlY1 = bind calcY(this._startX,this._startY,this._endX,this._endY); //this.dstartY + (this.dstartY + this.dendY)/2;
    override var controlY2 = bind calcY(this._endX,this._endY,this._startX,this._startY); //this.dstartY + (this.dstartY + this.dendY)/2;


    public var parentNode:LabelNode = null;
    public var childNode:LabelNode = null;

    override var effect = DropShadow {
                    radius: 4,
                    offsetY: 4,
                     offsetX: 4,
                }

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
