import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root
    property color disabledColor: "#E5E5E5"
    property color enabledColor: "black"
    property int fontsSize: 10

    signal sendPhone(string phone)

    function resetField() {
        phoneNumber.text = ""
    }

    Column {
        anchors.topMargin: 50
        anchors.fill: parent
        spacing: 10

        Image {
            width: 70; height: width
            anchors.horizontalCenter: parent.horizontalCenter
            source: "../images/logo.png"
        }        

        Item { width: parent.width; height: 10 }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: fontsSize
            text: "Enter your phone\n for SMS confirmation"
        }

        Item { width: parent.width; height: 5 }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4
            TextField {
                id: countryPhoneCode
                enabled: false
                width: 55
                horizontalAlignment: Text.AlignHCenter
                text: "+7"
                placeholderText: qsTr("SMS code")
                font.pointSize: fontsSize + 2

                style: TextFieldStyle {
                    textColor: "black"
                    background: Item {
                        Rectangle {
                            anchors.fill: parent
                        }
                        Rectangle {
                            anchors.topMargin: 2
                            anchors.top: parent.bottom
                            color: countryPhoneCode.activeFocus ? enabledColor : disabledColor
                            implicitWidth: parent.width
                            implicitHeight: 2
                        }
                    }
                }
            }
            TextField {
                id: phoneNumber
                width: 170
                focus: true
                horizontalAlignment: Text.AlignHCenter
                validator: RegExpValidator {regExp: /[0-9]{10}/}
                placeholderText: activeFocus ? "" : qsTr("phone number")
                font.pointSize: fontsSize + 2

                style: TextFieldStyle {
                    textColor: "black"
                    background: Item {
                        Rectangle {
                            anchors.fill: parent
                        }
                        Rectangle {
                            anchors.topMargin: 2
                            anchors.top: parent.bottom
                            color: phoneNumber.activeFocus ? enabledColor : disabledColor
                            implicitWidth: parent.width
                            implicitHeight: 2
                        }
                    }
                }

                onTextChanged: {
                    if(text.length < 10)
                        getCodeButton.enabled = false
                    else
                        getCodeButton.enabled = true
                }

                Keys.onPressed: {
                    if (((event.key === Qt.Key_Enter) || (event.key === Qt.Key_Return))
                        && (getCodeButton.enabled)) {
                        console.log("Phone Enter Key pressed!")
                        root.sendPhone(phoneNumber.text)
                        event.accepted = true;  // for prevent double execution
                    }
                }
            }
        }

        Item { width: parent.width; height: 20 }

        Button {
            id: getCodeButton
            enabled: false
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
                    text: "Get SMS code"
                    color: "white"
                    font.pointSize: fontsSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    console.log("Code Send Key pressed!")
                    root.sendPhone(phoneNumber.text)
                }
            }
        }

        Button {
            enabled: false
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 230
                    implicitHeight: 40
                    border.width: control.activeFocus ? 2 : 1
                    border.color: disabledColor
                    radius: 4
                    color: parent.enabled ? enabledColor : "white"
                }
                label: Text {
                    text: "Use oAuth"
                    color: parent.enabled ? "white" : "#666666"
                    font.pointSize: fontsSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }            

            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    console.log("Login Key pressed!")
                }
            }
        }
    }

}
