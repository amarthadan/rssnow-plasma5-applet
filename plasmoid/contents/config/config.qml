import QtQuick 2.0

import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: "akregator"
         source: "config/general.qml"
    }
    ConfigCategory {
         name: i18n("Feeds")
         icon: "akregator"
         source: "config/feeds.qml"
    }
}
