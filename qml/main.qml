import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import "styles" as Style

Window {
    id: root
    maximumWidth: 480
    minimumWidth: 480
    minimumHeight: 430
    maximumHeight: 430
    title: qsTr("Authorization Wizard")
    flags: Qt.Dialog
    visible: true

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: authRequestPage

        property bool busy: false

        Rectangle {
            id: busyMask

            z: 2
            anchors.fill: parent
            visible: stackView.busy
            color: "#70000000"

            BusyIndicator {
                id: indicator

                anchors.centerIn: parent
                width: 70; height: width

                style: Style.CustomBusyIndicatorStyle { }
            }
        }
    }

    Connections {
        target: Authenticator

        onAuthReRequest: {
            console.log("Authenticator response [sms code params]")
            stackView.busy = false

            stackView.pop(authCodePage)
            stackView.push({ item: authCodePage,
                             //immediate: true,
                             //replace: true,
                             properties:{codeLenght:length,
                                         codeDelay:delay*1000,
                                         codeRetries:retries}
                           })
        }

        onAuthReVerify: {
            console.log("Authenticator response [user profile:", name, avatarUrl, "]")
            stackView.busy = false

            stackView.push({ item: authConfirmPage,
                             properties:{userName:name,
                                         userAvatarUrl:avatarUrl}
                           })
        }
    }

    // 1st page
    Component {
        id: authRequestPage

        AuthRequest {
            id: authRequest

            onSendPhone: {
                stackView.busy = true
                Authenticator.phone = phone
            }
        }
    }

    // 2nd page
    Component {
        id: authCodePage

        AuthCode {
            id: authCode

            onSmsCodeEntered: {
                stackView.busy = true
                Authenticator.setAuthCode(code)
            }

            onCodeRepeated: {
                stackView.busy = true
                Authenticator.resend()
            }

            onAnotherCodeRequested: stackView.pop()
        }
    }

    // 3rd page
    Component {
        id: authConfirmPage

        AuthConfirm {
            id: authConfirm

            onProfileConfirmed: {
                Authenticator.confirmProfile()
                Qt.quit()
            }

            onProfileRejected: {
                stackView.clear()
                stackView.push({ item: authRequestPage, immediate: true })
            }
        }
    }
}
