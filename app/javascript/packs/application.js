// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

import '@fortawesome/fontawesome-free/js/all'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

$(document).ready(function () {
    let isPullDownMenuOpen = false;
    let isPopUpMenuOpen = false;

    $(document).on("click touchend", function (e) {
        if(isPopUpMenuOpen){
            if(!$(e.target).closest("#jquery-header-pop-up-menu").length){
                isPopUpMenuOpen=false;
                $("#jquery-header-pop-up-menu").hide();
            }
        }else{
            if($(e.target).closest("#jquery-header-user-button").length){
                isPopUpMenuOpen=true;
                $("#jquery-header-pop-up-menu").show();
            }
        }
    });
});
