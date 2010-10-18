package se.pearglans.fx;



/**
 * Created by IntelliJ IDEA.
 * User: karlw
 * Date: 2010-okt-04
 * Time: 13:04:13
 * To change this template use File | Settings | File Templates.
*
opa=$(find lib/ -name '*.jar' -printf "%f:")
tjo=$opa:target/scala_2.8.0/classes/
karlw@karlw-laptop:/var/karlw/src/scalafxjava$ ~/apps/javafx-sdk1.3/bin/javafxc -classpath $tjo:project/boot/scala-2.8.0/lib/scala-library.jar src/main/fx/se/pearglans/fx/*.fx 
karlw@karlw-laptop:/var/karlw/src/scalafxjava$ ~/apps/javafx-sdk1.3/bin/javafx -classpath $tjo:project/boot/scala-2.8.0/lib/scala-library.jar:src/main/fx/ se.pearglans.fx.HelloWorld

 */


import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.text.Font;
import javafx.stage.Stage;
// Scala project ScalaFactorial

import se.pearglans.fx.JavaFXScalaBridge;
import se.pearglans.ScalaEntry;

var stage: Stage;

def fxScalaBridge = JavaFXScalaBridge {
    initJavaFX: function(s: ScalaEntry): Void {
        // Show frame
        stage.visible = true;
    }
    // Called from Scala
    updateFactText: function(text: String): Void {
        factLabel.text = text;
    }
}

def font = Font {size: 24}

def factButton: Button = Button { font: font text: " 1 ! "
    var n = 1
    action: function() {
        n++;
        fxScalaBridge.calcFactorial(n);
        factButton.text = " {n} ! ";
    }
}

def factLabel = Label {font: font text: "1"}

stage = Stage { title: "JavaFX / Scala : Factorials" visible: false // !!
    onClose: function() { fxScalaBridge.closeScala(); }
    scene: Scene { width: 800 height: 60
        content: HBox {spacing: 20 content: [factButton, factLabel] }
    }
}

// Start JavaTaskBase
fxScalaBridge.start();
