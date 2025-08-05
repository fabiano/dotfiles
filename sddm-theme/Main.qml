import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    property int sessionIndex: session.index

    TextConstants { id: textConstants }
    ColorConstants { id: colorConstants }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            errorMessageText.color = colorConstants.blue
            errorMessageText.text = textConstants.loginSucceeded
        }

        function onLoginFailed() {
            passwordTextBox.text = ""

            errorMessageText.color = colorConstants.red
            errorMessageText.text = textConstants.loginFailed
        }

        function onInformationMessage(message) {
            errorMessageText.color = colorConstants.lightWhite
            errorMessageText.text = message
        }
    }

    Rectangle {
        anchors.fill: parent
        color: colorConstants.background

        Column {
            id: mainColumn
            anchors.centerIn: parent
            spacing: 20

            Column {
                width: parent.width
                spacing: 4
                
                Text {
                    id: nameLabel
                    font.capitalization: Font.AllUppercase
                    text: textConstants.userName
                    width: parent.width

                    color: colorConstants.lightBlack
                }

                TextBox {
                    id: nameTextBox
                    text: userModel.lastUser
                    width: parent.width

                    borderColor: colorConstants.textBoxBackground
                    color: colorConstants.textBoxBackground
                    focusColor: colorConstants.textBoxBackground
                    hoverColor: colorConstants.textBoxBackground
                    textColor: colorConstants.lightWhite

                    KeyNavigation.backtab: rebootButton
                    KeyNavigation.tab: passwordTextBox

                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(nameTextBox.text, passwordTextBox.text, sessionIndex)

                            event.accepted = true
                        }
                    }
                }
            }

            Column {
                width: parent.width
                spacing : 4

                Text {
                    id: passwordLabel
                    font.capitalization: Font.AllUppercase
                    text: textConstants.password
                    width: parent.width

                    color: colorConstants.lightBlack
                }

                PasswordBox {
                    id: passwordTextBox
                    width: parent.width

                    borderColor: colorConstants.textBoxBackground
                    color: colorConstants.textBoxBackground
                    focusColor: colorConstants.textBoxBackground
                    hoverColor: colorConstants.textBoxBackground
                    textColor: colorConstants.lightWhite

                    KeyNavigation.backtab: nameTextBox
                    KeyNavigation.tab: loginButton

                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(nameTextBox.text, passwordTextBox.text, sessionIndex)
                            
                            event.accepted = true
                        }
                    }
                }
            }

            Column {
                width: parent.width

                Text {
                    id: errorMessageText
                    font.capitalization: Font.AllUppercase
                    horizontalAlignment: Text.AlignHCenter
                    text: textConstants.prompt
                    width: parent.width

                    color: colorConstants.lightBlack
                }
            }

            Row {
                spacing: 10

                property int btnWidth: Math.max(loginButton.implicitWidth, shutdownButton.implicitWidth, rebootButton.implicitWidth, 80) + 8

                Button {
                    id: loginButton
                    font.bold: false
                    font.capitalization: Font.AllUppercase
                    text: textConstants.login
                    width: parent.btnWidth

                    borderColor: colorConstants.textBoxBackground
                    color: colorConstants.textBoxBackground
                    textColor: colorConstants.lightWhite
                    disabledColor: colorConstants.lightBlack
                    activeColor: colorConstants.textBoxBackground
                    pressedColor: colorConstants.textBoxBackground

                    onClicked: sddm.login(nameTextBox.text, passwordTextBox.text, sessionIndex)

                    KeyNavigation.backtab: passwordTextBox; KeyNavigation.tab: shutdownButton
                }

                Button {
                    id: shutdownButton
                    font.bold: false
                    font.capitalization: Font.AllUppercase
                    text: textConstants.shutdown
                    width: parent.btnWidth

                    borderColor: colorConstants.red
                    color: colorConstants.red
                    textColor: colorConstants.lightWhite
                    disabledColor: colorConstants.lightBlack
                    activeColor: colorConstants.red
                    pressedColor: colorConstants.red

                    onClicked: sddm.powerOff()

                    KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                }

                Button {
                    id: rebootButton
                    font.bold: false
                    font.capitalization: Font.AllUppercase
                    text: textConstants.reboot
                    width: parent.btnWidth

                    borderColor: colorConstants.red
                    color: colorConstants.red
                    textColor: colorConstants.lightWhite
                    disabledColor: colorConstants.lightBlack
                    activeColor: colorConstants.red
                    pressedColor: colorConstants.red

                    onClicked: sddm.reboot()

                    KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: nameTextBox
                }
            }
        }
    }

    Component.onCompleted: {
        if (nameTextBox.text == "")
            nameTextBox.focus = true
        else
            passwordTextBox.focus = true
    }
}
