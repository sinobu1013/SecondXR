import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import QtQuick3D.Helpers
import QtQuick3D
import QtQuick3D.Xr

XrView {
    id: xrView
    referenceSpace: XrView.ReferenceSpaceStage

    property bool preferPassthrough: true
    passthroughEnabled: passthroughSupported && preferPassthrough

    environment: SceneEnvironment {
        clearColor: "skyblue"
        backgroundMode: xrView.passthroughEnabled ? SceneEnvironment.Transparent : SceneEnvironment.Color
    }

    //! [hand component]
    component Hand : Node {
        id: handComponentRoot
        property color color: "#ddaa88"
        required property int touchId
        property alias hand: handModel.hand
        property vector3d touchPosition: handController.pokePosition

        onTouchPositionChanged: {
            const scenePos = theOrigin.mapPositionToScene(touchPosition)
            teapotNode.handleTouch(scenePos)

            if(teapotNode.picked){
                teapotNode.position = scenePos.minus(teapotNode.relativeOffset);
                teapotNode.rotation = handController.rotation;
            }
        }

        XrController {
            id: handController
            controller: handComponentRoot.hand
        }
        XrHandModel {
            id: handModel
            materials: PrincipledMaterial {
                baseColor: handComponentRoot.color
                roughness: 0.5
            }
        }
    }

    xrOrigin: theOrigin
    XrOrigin {
        id: theOrigin
        z: 0
        Hand {
            id: rightHandModel
            hand: XrHandModel.RightHand
            touchId: 0
        }
        Hand {
            id: leftHandModel
            hand: XrHandModel.LeftHand
            touchId: 1
        }
    }

    //! [trigger input]
    XrInputAction {
        id: rightTrigger
        hand: XrInputAction.RightHand
        actionId: [XrInputAction.TriggerPressed, XrInputAction.TriggerValue, XrInputAction.IndexFingerPinch]
        onTriggered: {
            console.log("right hand touch!!")

            if(teapotNode.touched){
                teapotNode.picked = !teapotNode.picked
            }

            if(teapotNode.picked) {
                const scenePos = theOrigin.mapPositionToScene(rightHandModel.touchPosition)
                teapotNode.relativeOffset = scenePos.minus(teapotNode.scenePosition)

            }
        }
    }

    DirectionalLight {
        eulerRotation.x: -30
        eulerRotation.y: -70
    }

    Node {
        id: teapotNode
        x: 0
        y: 0
        z: -100
        property bool touched: false
        property bool picked: false
        property vector3d relativeOffset: Qt.vector3d(0,0,-10)

        function handleTouch(touchPos: vector3d) {
            const localPos = mapPositionFromScene(touchPos)
            const touchRange = Math.max(teapot.scale.x, teapot.scale.y, teapot.scale.z) / 3
            touched = Math.abs(localPos.x) < touchRange && Math.abs(localPos.y) < touchRange && Math.abs(localPos.z) < touchRange

            if(touched && !picked) {
                console.log("touch!!")
                teapot.color = Qt.color("red")
            }else{
                console.log("Not touch")
                teapot.color = Qt.color("blue")
            }

        }
        Model {
            id: teapot
            source: "meshes/teapot.mesh"
            scale: Qt.vector3d(10, 10, 10)
            property color color: "white"

            pickable: true
            objectName: "teapot"
            materials: [
                PrincipledMaterial {
                    baseColor: teapot.color
                    roughness: 0.1
                    clearcoatRoughnessAmount: 0.1
                    metalness: metalnessCheckBox.checked ? 1.0 : 0.0
                }
            ]
        }
    }
}
