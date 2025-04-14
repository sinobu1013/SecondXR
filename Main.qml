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
            // console.log("rightTrigger.pressed", rightTrigger.pressed, teapotNode.touched)

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

        XrCamera {
            property vector3d now_position: Qt.vector3d(0,170,0)
            property vector3d now_rota: Qt.vector3d(0,0,0)
            property vector3d boardPosition: Qt.vector3d(0,170,-100)
            onPositionChanged: {
                // console.log("position: ", position)
                // console.log("boardNode position : ", boardNode.position)
                boardNode.x += position.x - now_position.x
                boardNode.y += position.y - now_position.y
                boardNode.z += position.z - now_position.z
                now_position = position
            }
            onEulerRotationChanged: {
                console.log("kakudo: ", eulerRotation)
                console.log("now_kakudo: ", now_rota)
                boardNode.eulerRotation = eulerRotation
                let x = rotation
                // console.log("rotation", x.toEulerAngles())
                // if(Math.abs(eulerRotation.y - now_rota.y) > 30){
                    y_turn(eulerRotation, now_rota)
                    now_rota = eulerRotation
                // }
                console.log("y_turn", boardNode.position)
            }

            function y_turn(now: vector3d, old: vector3d) {
                let ans = Qt.vector3d(0,0,0)
                let temp = Qt.vector3d(0,0,0)
                temp.x = now.x - old.x
                temp.y = now.y - old.y
                temp.z = now.z - old.z
                // if(Math.abs(temp.y) < 1) return
                console.log("temp.y : ", (temp.y * Math.PI) / 180)
                let cos = Math.cos((temp.y * Math.PI) / 180)
                let sin = Math.sin((temp.y * Math.PI) / 180)
                ans.x = boardNode.x * cos + boardNode.z * sin
                ans.y = boardNode.y
                ans.z = boardNode.x * sin * -1 + boardNode.z * cos
                // boardNode.x = 100 * Math.sin(now.y)
                // boardNode.y = ans.y
                // boardNode.z = 100 * Math.cos(now.y)
                boardNode.x = ans.x
                boardNode.y = ans.y
                boardNode.z = ans.z
            }

            // function y_turn(now: vector3d) {
            //     let ans = Qt.vector3d(0,0,0)
            //     if(Math.abs(now.y) < 1) return
            //     let cos = Math.cos(now.y)
            //     let sin = Math.sin(now.y)
            //     ans.x = boardNode.x * cos + boardNode.z * sin
            //     ans.y = boardNode.y
            //     ans.z = boardNode.x * sin * -1 + boardNode.z * cos
            //     boardNode.x = ans.x
            //     boardNode.y = ans.y
            //     boardNode.z = ans.z
            // }
        }
    }
    xrOrigin: theOrigin

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
                // const scenePos = theOrigin.mapPositionToScene(rightHandModel.touchPosition)
                // teapotNode.relativeOffset = scenePos.minus(teapotNode.scenePosition)
            }
        }
    }

    XrVirtualMouse {
        view: xrView
        source: rightHandModel
        leftMouseButton: rightTrigger.pressed
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
        property real count: 0

        function handleTouch(touchPos: vector3d) {
            const localPos = mapPositionFromScene(touchPos)
            const touchRange = Math.max(teapot.scale.x, teapot.scale.y, teapot.scale.z)/3
            touched = Math.abs(localPos.x) < touchRange && Math.abs(localPos.y) < touchRange && Math.abs(localPos.z) < touchRange
            count += 1
            // console.log("count: ", count)

            if(touched && !picked) {
                // console.log("touch!!")
                teapot.color = Qt.color("red")
            }else{
                // console.log("Not touch")
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

    Node {
        id: boardNode
        objectName: boardNode
        x: 0
        y: 170
        z: -100
        Rectangle {
            id: board
            width: 50
            height: 50
            color: "red"
        }
    }
}
