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

    // //! [hand component] (省略)
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
                // 回転も手に追従させる場合は handController.rotation を使う
                // teapotNode.rotation = handController.rotation;
                // もしくは、手で掴んでいる間は向きを変えないなら何もしない
            }
        }

        XrController {
            id: handController
            controller: handComponentRoot.hand
        }
        XrHandModel {
            id: handModel
            // hand プロパティは Component の呼び出し元で設定
            materials: PrincipledMaterial {
                baseColor: handComponentRoot.color
                roughness: 0.5
            }
        }
    }
    // //! [hand component] end

    XrOrigin {
        id: theOrigin

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

        // --- 修正箇所 ---
        // カメラからの boardNode の相対的なオフセット (例: Y軸に少し上、Z軸に1メートル前)
        // Qtの3D座標系は通常メートル単位です。y: 170 は 170m になってしまうため、
        // 1.7m (170cm) の高さにしたい場合は 1.7 とします。
        // Z軸は手前が正、奥が負なので、前方に置くには負の値を指定します。
        property vector3d boardOffset: Qt.vector3d(0, -0.1, -1.0) // 例: 目線より少し下、1m前

        function rotateVector(v :vector3d, q :QQuaternion) {
            const qv = Qt.quaternion(0, v.x, v.y, v.z);
            const rotated_qv = q.times(qv).times(q.conjugated());
            return Qt.vector3d(rotated_qv.x, rotated_qv.y, rotated_qv.z);
        }

        // boardNode の位置と回転を更新する関数
        function updateBoardNodeTransform() {
            if (!camera || !boardNode) return; // オブジェクトが存在しない場合は何もしない

            // カメラの現在のワールド座標での回転（クォータニオン）
            const cameraRotation = camera.rotation;
            // カメラの現在のワールド座標での位置
            const cameraPosition = camera.position;

            // オフセットベクトルをカメラの現在の向きに合わせて回転させる
            const rotatedOffset = rotateVector(boardOffset, cameraRotation);

            // カメラの現在位置に、回転させたオフセットを加算して boardNode の位置を決定
            boardNode.position = cameraPosition.plus(rotatedOffset);

            // boardNode の向きをカメラの向きに合わせる
            boardNode.rotation = cameraRotation;
            // または boardNode.eulerRotation = camera.eulerRotation;
        }
        // --- 修正箇所ここまで ---

        XrCamera {
            id: camera // カメラにIDを付与
            // 初期位置 (メートル単位と仮定)
            // y: 1.7 // 170cm の高さ

            // Componentが完了した時点（初期状態）で一度更新
            Component.onCompleted: {
                updateBoardNodeTransform();
            }

            // カメラの位置が変わったら boardNode の位置と回転を更新
            onPositionChanged: {
                // console.log("Camera Position:", position)
                theOrigin.updateBoardNodeTransform()
                // 以前のコード (now_position を使う差分更新) は削除
            }

            // カメラの回転が変わったら boardNode の位置と回転を更新
            // eulerRotationChanged ではなく rotationChanged を使う方が確実
            onRotationChanged: {
                // console.log("Camera Rotation:", rotation)
                theOrigin.updateBoardNodeTransform()
                // 以前のコード (y_turn 関数呼び出し) は削除
            }
            // y_turn 関数は不要なので削除
        }

        Node {
            id: boardNode
            objectName: "boardNode" // objectName は通常文字列リテラル
            // 初期位置と回転は updateBoardNodeTransform で設定されるので不要
            z: -50
            y: 170

            // Rectangle は2D要素のため、3D空間に表示するには Model を使うのが一般的
            // 例: 50cm x 50cm の平面メッシュを使う
            Rectangle {
                width: 20
                height: 20
                color: "red"
            }

            /*
            // 元の Rectangle を使いたい場合は Texture として Model に貼るなどの工夫が必要
            Rectangle {
                id: board
                width: 50 // 単位はピクセル
                height: 50
                color: "red"
            }
            */
        }

    }
    xrOrigin: theOrigin // XrView に XrOrigin を設定

    // //! [trigger input] (省略)
    XrInputAction {
        id: rightTrigger
        hand: XrInputAction.RightHand
        // actionId: [XrInputAction.TriggerPressed, XrInputAction.TriggerValue, XrInputAction.IndexFingerPinch]
        // シンプルにするなら TriggerPressed のみでも良いかも
        actionId: XrInputAction.TriggerPressed
        onTriggered: {
            console.log("Right Trigger Pressed!", rightTrigger.pressed) // pressed は true/false

            if(teapotNode.touched){
                teapotNode.picked = !teapotNode.picked // Pick状態をトグル
                console.log("Teapot Picked:", teapotNode.picked)

                // 掴んだ瞬間に相対オフセットを計算
                if (teapotNode.picked) {
                    const scenePos = theOrigin.mapPositionToScene(rightHandModel.touchPosition)
                    teapotNode.relativeOffset = scenePos.minus(teapotNode.position)
                }
            }
        }
    }

    XrVirtualMouse {
        view: xrView
        source: rightHandModel
        leftMouseButton: rightTrigger.pressed // XrInputAction の pressed プロパティを参照
    }
    // //! [trigger input] end

    DirectionalLight {
        eulerRotation.x: -30
        eulerRotation.y: -70
        castsShadow: true // 影を有効にする場合
        brightness: 1.0
    }

    Node {
        id: teapotNode
        // 初期位置 (メートル単位と仮定)
        x: 0
        y: 1.6 // 少し低い位置
        z: -1.0 // 1m前
        property bool touched: false
        property bool picked: false
        property vector3d relativeOffset: Qt.vector3d(0,0,0) // 掴んだ時の相対位置
        // property real count: 0 // デバッグ用なら残しても良い

        function handleTouch(touchPos: vector3d) {
            // ワールド座標の touchPos を teapotNode のローカル座標に変換
            const localPos = mapPositionFromScene(touchPos)
            // ティーポットのスケールに応じたタッチ範囲 (より正確にはバウンディングボックスを使うべき)
            const touchRange = Math.max(teapot.scale.x, teapot.scale.y, teapot.scale.z) * 10 / 2 // スケールが10なので /2 で半径相当
            touched = localPos.length() < touchRange // 中心からの距離で判定 (より単純)
            // touched = Math.abs(localPos.x) < touchRange && Math.abs(localPos.y) < touchRange && Math.abs(localPos.z) < touchRange

            // count += 1
            // console.log("Teapot localPos:", localPos, "Touched:", touched)

            if(touched && !picked) {
                teapot.color = Qt.color("red") // ハイライト色
            } else if (!picked) { // 触れていない、かつ掴まれていない場合のみ色を戻す
                teapot.color = Qt.color("lightblue") // 元の色に戻す (whiteだと見にくい場合がある)
            }
            // 掴まれている間は色を変えない、などの調整も可能
        }

        Model {
            id: teapot
            source: "meshes/teapot.mesh"
            scale: Qt.vector3d(0.1, 0.1, 0.1) // スケールをメートル単位に合わせる (例: 10cmサイズ)
            property color color: "lightblue" // 初期色

            pickable: true // マウスイベント等を受け取る場合 (XrVirtualMouse で使うなら不要かも)
            objectName: "teapot"
            materials: [
                PrincipledMaterial {
                    baseColor: teapot.color
                    roughness: 0.3
                    metalness: 0.1 // 少し金属っぽくする場合
                    // metalness: metalnessCheckBox.checked ? 1.0 : 0.0 // チェックボックスがある場合
                }
            ]
        }
    }
}
