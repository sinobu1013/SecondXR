import QtQuick
import QtQuick3D.Helpers
import QtQuick3D
import QtQuick3D.Xr

Node {
    id: pointCom
    property real scaleValue: 0.025

    Model {
        source: "#Sphere"
        materials: PrincipledMaterial { baseColor: "red" }
        scale: Qt.vector3d(scaleValue, scaleValue, scaleValue)
    }
}
