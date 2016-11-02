import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: root

    property color disabledColor: "#E5E5E5"
    property color enabledColor: "black"
    property int fontsSize: 10

    property int codeLenght: 0
    property double codeDelay: 0
    property int codeRetries: 0

    signal smsCodeEntered(string code)
    signal codeRepeated()
    signal anotherCodeRequested()

    Timer {
        id: codeExpireTimer
        interval: 1000
        repeat: true
        onTriggered: {
//            console.log("codeExpireTimer tick")
            codeDelay = codeDelay - 1000
            codeTimeText.text = Authenticator.secondsToDHMS(codeDelay/1000)
            if(codeDelay === 0) {
                codeExpireTimer.stop()
                codeTextItem.visible = false
                repeatCodeText.visible = true
                anotherPhoneButton.enabled = true
            }
        }
    }

    function setup(length, delay, retries) {
        userNumber.text = Authenticator.phone
        codeLenght = length
        codeDelay = delay * 1000    // to msec
        codeExpireTimer.start()
        codeTimeText.text = Authenticator.secondsToDHMS(codeDelay/1000)
        //console.log("codeExpireTimer interval", codeExpireTimer.interval)
    }

    onCodeDelayChanged: {
        userNumber.text = Authenticator.phone
        codeExpireTimer.start()
        codeTimeText.text = Authenticator.secondsToDHMS(codeDelay/1000)
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

        Column {
            width: parent.width;
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            Label {
                width: parent.width;
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: fontsSize
                text: "Code has been sended to number"
            }
            Label {
                id: userNumber
                width: parent.width;
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: fontsSize + 2
            }
        }

        Item { width: parent.width; height: 1 }

        TextField {
            id: smsCode
            width: 110
            focus: true
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            validator: RegExpValidator {regExp: new RegExp('[0-9]{'+codeLenght+'}')}     // check codeLenght correspondence /[0-9]{4}/
            placeholderText: activeFocus ? "" : qsTr("SMS code")
            font.pointSize: fontsSize + 2

            style: TextFieldStyle {
                textColor: "black"
                background: Item {
                    Rectangle {
                        anchors.fill: parent
                    }
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 2
                        anchors.top: parent.bottom
                        color: smsCode.activeFocus ? enabledColor : disabledColor
                        implicitWidth: parent.width - 20
                        implicitHeight: 2
                    }
                }
            }

            onTextChanged: {
                if(text.length >= codeLenght)
                    root.smsCodeEntered(smsCode.text)
            }
        }

        Item { width: parent.width; height: 10 }

        Column {
            width: parent.width;
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                id: codeTextItem
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: fontsSize
                    text: "Code repeat available after"
                }
                Label {
                    id: codeTimeText
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: fontsSize
                }
            }
            Label {
                id: repeatCodeText
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                color: "darkblue"
                font.pointSize: fontsSize
                text: "Resend SMS code"
                MouseArea {
                    anchors.fill: parent
                    onClicked:  {
                        console.log("Repeat Code Label pressed!")
                        root.codeRepeated()
                    }
                }
            }
        }

        Item { width: parent.width; height: 10 }

        /*
        Button {
            id: setCodeButton
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
                    text: "Далее"
                    color: "white"
                    font.pointSize: fontsSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    root.smsCodeEntered(smsCode.text)
                }
            }
        }*/

        Button {
            id: anotherPhoneButton
            enabled: false
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
                    text: "Another numbers"
                    color: parent.enabled ? "white" : "#666666"
                    font.pointSize: fontsSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.anotherCodeRequested()
            }
        }
    }

}
