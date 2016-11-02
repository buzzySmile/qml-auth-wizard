import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Item {
    id: root

    property color disabledColor: "#E5E5E5"
    property color enabledColor: "black"
    property color secondaryColor: "gray"
    property int fontsSize: 10

    signal profileConfirmed()
    signal profileRejected()

    property alias userName: userNameLabel.text
    property alias userAvatarUrl: userAvatar.source

    Column {
        anchors.topMargin: 50
        anchors.fill: parent
        spacing: 10

        Item {
            id: avatarItem
            anchors.horizontalCenter: parent.horizontalCenter
            height: 90
            width: height

            Image {
                id: userAvatar
                width: parent.width;  height: parent.height
                sourceSize: Qt.size(parent.width, parent.height)

                smooth: true
                visible: false
                fillMode: Image.PreserveAspectCrop
                //asynchronous: true
            }

            Rectangle {
                id: mask
                width: parent.width;  height: parent.height
                radius: parent.height/2
                smooth: true
                visible: false
            }

            OpacityMask {
                anchors.fill: userAvatar
                source: userAvatar
                maskSource: mask
            }
        }

        Item { width: parent.width; height: 10 }

        Column {
            width: parent.width;
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Label {
                id: userNameLabel
                width: parent.width;
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: fontsSize + 2
            }
            Label {
                width: parent.width;
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: fontsSize
                text: "Your profile founded"
            }
        }

        Item { width: parent.width; height: 20 }

        Button {
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 230
                    implicitHeight: 40
                    //border.width: control.activeFocus ? 2 : 1
                    //border.color: "#888"
                    radius: 4
                    color: parent.enabled ? enabledColor : disabledColor
                }
                label: Text {
                    text: "Login as " + String(userNameLabel.text).split(" ", 1)
                    color: "white"
                    font.pointSize: fontsSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    console.log("Login Key pressed!")
                    root.profileConfirmed()
                }
            }
        }

        Button {
            id: notMeButton

            anchors.horizontalCenter: parent.horizontalCenter
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 230
                    implicitHeight: 40
                    border.width: control.activeFocus ? 2 : 1
                    border.color: disabledColor
                    radius: 4
                    color: parent.enabled ? secondaryColor : "white"
                }
                label: Text {
                    text: "Not me"
                    color: parent.enabled ? "white" : "#666666"
                    font.pointSize: fontsSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }            

            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    //console.log("Not Me Key pressed!")
                    root.profileRejected()
                }
            }
        }
    }

}
