package se.pearglans.fx;

import javafx.stage.Stage;
import javafx.scene.Scene;
import javafx.scene.control.Slider;
import com.cedarsoft.fx.JavaFxBridge;
import com.sun.javafx.runtime.FXObject;
import javafx.animation.Timeline;
import javafx.animation.KeyFrame;

import se.pearglans.JavaClass;
/**
 * @author johannes
 */
var slider: Slider;

//The java model class. Contains the property "amount" and a PropertyChangeSupport
def javaModel = new JavaClass();

Stage {
  title: "Application title"
  scene: Scene {
    width: 800
    height: 600
    content: [
      slider = Slider {
          min: 1
          max: 100
          snapToTicks: true
        }
    ]
  }
}

//Create the binding from the java model to the slider
//Using the defaults:
// Java --> FX: PropertyChangeEvents
// FX --> Java: Calling setters by reflection
JavaFxBridge.bridge( javaModel ).to( slider as FXObject ).connecting(
  JavaFxBridge.bind( "amount" ).to( "value" ).withInverse()
); //sorry for the stupid API - needs some polishing...

//Add a timeline to simulate changes to the model
Timeline {
  repeatCount: Timeline.INDEFINITE
  keyFrames: [
    KeyFrame {
      time: 5s
      action: function() {
        println("changing amount on model");
        javaModel.setAmount( javaModel.getAmount() + 10 );
      }
    }
  ];
}.play();