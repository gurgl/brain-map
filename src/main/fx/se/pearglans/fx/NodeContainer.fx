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
        print("innan Node");
        print(node);
        var children = node.getChildren();
        for(l in children) {
        //for(l in [0..children.length-1]) {
            var n = l as MNode;
            populateTree(node, n)
        }
    }


    package function insertNode(parent:MNode, node:MNode) : LabelNode {
        var label = LabelNode {
            data: node
        }
        label.bindit();
        label.setNonEditable();
        insert label into StageBase.drawArea.content;

        var parentLbl:LabelNode = null;
        for(obj in StageBase.drawArea.content) {
            if(obj instanceof LabelNode) {
                var ln = obj as LabelNode;
                if(ln.data == parent) {
                    parentLbl = ln;
                }
            }
        }
        if(parentLbl != null) {

            var apa:Number = 0;
            var cubicCurve = NodeConnector {
                fill: Color.TRANSPARENT,
                stroke: Color.RED,
                parentNode: parentLbl,
                childNode:label
            };

            insert cubicCurve into StageBase.drawArea.content;
        }
        return label;
    }
}
