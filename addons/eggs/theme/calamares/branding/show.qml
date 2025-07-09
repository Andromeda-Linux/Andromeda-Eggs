import QtQuick 2.0
import calamares.slideshow 1.0

Presentation
{
    id: presentation

    function nextSlide() {
        presentation.goToNextSlide();
    }

    Timer {
        id: advanceTimer
        interval: 10000 // 10 sekund
        running: true
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
        Image {
            source: "image.png"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
    }

    Slide {
        Image {
            source: "image1.png"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
    }

    Slide {
        Image {
            source: "image2.png"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
    }

    Slide {
        Image {
            source: "image3.png"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
    }

    Slide {
        Image {
            source: "image4.png"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }
    }

    function onActivate() {
        presentation.currentSlide = 0;
    }

    function onLeave() {}
}
