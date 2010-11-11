package se.pearglans.fx;

/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-okt-04
 * Time: 13:09:01
 * To change this template use File | Settings | File Templates.
 */

import javafx.async.JavaTaskBase;
import javafx.async.RunnableFuture;
// Scala project ScalaFactorial
import se.pearglans.*;
import javafx.scene.Node;


package class JavaFXScalaBridge extends JavaTaskBase, ScalaToJavaFX {

    // Access to scala project
    var scalaEntry: ScalaEntry;

    // JavaFX Script -> Scala

    package function calcFactorial(i: Integer): Void {
        scalaEntry.calcFact(i);
    }

    package function getModel(): MNode {
        print("WTF1");
        var r = se.pearglans.Tjo.getModel();
        print(r);
        print("SLT");
        return r;
    }

    package function add(item:MNode,target:MNode): Void {
        scalaEntry.addNode(item,target);
    }

    package function sync(item:MNode,screenNodes:Node[]): Void {
        

        //scalaEntry.sync(item,nodes);
        []
    }



    package function closeScala(): Void {
        scalaEntry.closeScala();
    }

    // Scala -> JavaFX Script

    // Implemented in JavaFXMain, called here from 'onDone'
    package var initJavaFX: function(s: ScalaEntry): Void;
    // Implemented in JavaFXMain, called here from 'updateFact'
    package var updateFactText: function(text: String): Void;

    package var updateTreeNode: function(text: MNode): Void;

    // Interface ScalaToJavaFX

    // Called from within ScalaEntry
    override function updateFact(number: String): Void {
        FX.deferAction(
            // Called on JavaFX-EDT
            function(): Void {
                updateFactText(number);
        });
    };

    override function updateTree(node: MNode): Void {
        FX.deferAction(
            // Called on JavaFX-EDT
            function(): Void {
                updateTreeNode(node);
        });
    };

    

    // Implementation of JavaTaskBase
    // JavaTaskBase provides a way to run Java/Scala application code
    // on a thread other than the JavaFX event dispatch thread (EDT).

    // Create RunnableFuture: ScalaEntry
    // Called in function 'start()'
    protected override function create(): RunnableFuture {
        scalaEntry = new ScalaEntry(this);
    }
    // Called from JavaFXMain
    // Initializes scala code : calls run() on RunnableFuture 'scalaEntry'
    protected override function start(): Void {
        // Nothing to do
        super.start();
    }
    // Callback: Finish init
    override var onDone = function(): Void {
        initJavaFX(scalaEntry);
    };
}

