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
import javafx.scene.shape.ClosePath;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.KeyEvent;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.Container;
import javafx.animation.*;
import javafx.animation.transition.*;

import com.cedarsoft.fx.JavaFxBridge;
import com.sun.javafx.runtime.FXObject;


// Scala project ScalaFactorial

import se.pearglans.fx.JavaFXScalaBridge;
import se.pearglans.*;
import se.pearglans.Tjo;

import LabelNode;

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-nov-11
 * Time: 20:07:19
 * To change this template use File | Settings | File Templates.
 */
package class NodeContainer extends Group {


    package function populateTree(parent:MNode, node:MNode) : Void {
        var label = insertNode(parent, node);
        label.setSelected(true);
        //print("innan Node");
        //print(node);
        var children = node.getChildren();
        for(l in children) {
        //for(l in [0..children.length-1]) {
            var n = l as MNode;
            populateTree(node, n)
        }
    }

    package function getAllLabelNodes() {
        var nodes:LabelNode[] = [];
        for(obj in StageBase.drawArea.content) {
            if(obj instanceof LabelNode) {
                insert (obj as LabelNode) into nodes;
            }
        }
        return nodes;
    }

    package function findNodeByModel(parent:MNode) : LabelNode {
        for(obj in StageBase.drawArea.content) {
            if(obj instanceof LabelNode) {
                var ln = obj as LabelNode;
                if(ln.data == parent) {
                    return ln;
                }
            }
        }
        return null;
    }

    package function removeNode(node:LabelNode) : LabelNode {
        println("ACTION : REMOVE NODE");
        var newParent = Tjo.removeNode(node.data);
        var nodesToRemove = Tjo.flatten(node.data);
        for(obj in nodesToRemove) {
            var lblNode = findNodeByModel(obj);
            delete lblNode.parentConnector from content;
            delete lblNode from content;
        }
        var newSelected = findNodeByModel(newParent);
        return newSelected;                
    }

    package function scrollToNodeInDirection(l:LabelNode, dir:Direction, stage:Stage) : Void {
        var nearest = findNearest(dir,l);
        if(nearest != null) {
            nearest.setSelected(true);
            scrollToNodeAnimated(nearest,stage);
        }
    }
    var currentScroll : PathTransition = null;

    package function scrollTo(p:Point2D, stage:Stage) : Void {
        var w = this.boundsInLocal.maxX/2;
        var h = this.boundsInLocal.maxY/2;

        this.translateX = p.x();
        this.translateY = p.y();

    }


    package function scrollToNodeAnimated(l:LabelNode, stage:Stage) : Void {



        if(this.currentScroll != null) {
            this.currentScroll.stop();
            this.currentScroll = null;
        }
        var p =  l.data.pos();

        var container = this;
        
        //println(container.translateY);
        //println(container.translateX);
        //this.translateY = stage.height/2 - p.y();
        //this.translateX = stage.width/2 - p.x();


        var w = this.boundsInLocal.maxX/2;
        var h = this.boundsInLocal.maxY/2;

        var oX = w + container.translateX;
        var oY = h + container.translateY;
        println("{container.translateX} {container.translateY}");

        println("T {oX} {oY}");
        println("S {w} {h}");
        var dx = ( w - p.x() );
        var dy = ( h - p.y() );

        var nx = w +  dx;
        var ny = h +  dy;

        /*if (1 == 1) {
            scrollTo(new Point2D(dx,dy),stage);
            return ;
        }*/

        println("D {dx} {dy}");
        def track = [
            MoveTo {
                x: oX
                y: oY
            },
            LineTo {
                x: nx   //- stage.width/2 - p.x()
                y: ny // - h)//- stage.height/2 - p.y()
            },
            

        ];
        def mpath = Path {
            stroke: Color.TRANSPARENT
            elements:track
        };

        def anim = PathTransition {
            path: AnimationPath.createFromPath(mpath)
            orientation: OrientationType.NONE
            node: container
            interpolator: Interpolator.LINEAR
            duration: 0.3s
            repeatCount: 1
        };
        this.currentScroll = anim;
        anim.play();
    }

    package function insertNode(parent:MNode, node:MNode) : LabelNode {
        var label = LabelNode {
            data: node
        }
        label.bindit();
        label.setNonEditable();
        insert label into StageBase.drawArea.content;

        var parentLbl:LabelNode = findNodeByModel(parent);

        if(parentLbl != null) {

            var apa:Number = 0;
            var cubicCurve = NodeConnector {
                fill: Color.TRANSPARENT,
                parentNode: parentLbl,
                childNode:label
            };

            label.parentConnector = cubicCurve;

            insert cubicCurve into StageBase.drawArea.content;
        }
        return label;
    }
    /*package function getDistance(code:Int, n1:LabelNode, n2:LabelNode) : Number {

    }*/

    package function getDirection(code:KeyCode) : Direction {
     var dir:Direction = null;
        if(code == KeyCode.VK_LEFT) {
            dir = Direction.LEFT;
        } else if(code == KeyCode.VK_RIGHT) {
            dir = Direction.RIGHT;
        } else if(code == KeyCode.VK_UP) {
            dir = Direction.UP;
        } else if(code == KeyCode.VK_DOWN) {
           dir = Direction.DOWN;
        } else { }
        return dir;
    }

    package function findNearest(dir:Direction, origin:LabelNode) : LabelNode {

        //println("tho");
        var foundMNode = NodeHelper.findNearest(dir, origin.data);
        var foundLabelNode = findNodeByModel(foundMNode);
        return foundLabelNode;
    }
}
import se.pearglans.NodeHelper;
import se.pearglans.Direction;
