module Confetti
  module Template
    class IosInfo < Base
      ORIENTATIONS_MAP = {
        :landscape => [
          "UIInterfaceOrientationLandscapeLeft",
          "UIInterfaceOrientationLandscapeRight"
        ],
        :portrait => [
          "UIInterfaceOrientationPortrait",
          "UIInterfaceOrientationPortraitUpsideDown"
        ],
        :default => [
          "UIInterfaceOrientationPortrait",
          "UIInterfaceOrientationPortraitUpsideDown",
          "UIInterfaceOrientationLandscapeLeft",
          "UIInterfaceOrientationLandscapeRight"
        ]
      }

      STATUS_BARS = {
        :default              => "UIStatusBarStyleDefault",
        :"black-translucent"  => "UIStatusBarStyleBlackTranslucent",
        :"black-opaque"       => "UIStatusBarStyleBlackOpaque"
      }

      def icons
        @config.plist_icon_set
      end

      def bundle_identifier
        @config.package
      end

      def bundle_version
        @config.version_string
      end

      def product_name
        @config.name.name
      end

      def output_filename
        "Info.plist"
      end

      def devices 
        nibs = ["NSMainNibFile"]

        @config.preference_set.each do |preference|
          next unless preference.name
          nibs << "NSMainNibFile~ipad" if preference.name.match /^universal$/
        end

        nibs
      end

      def app_orientations
        ORIENTATIONS_MAP[@config.orientation]
      end

     def exit_on_suspend?
        @config.preference("exit-on-suspend") == :true
     end

      def fullscreen?
        @config.preference(:fullscreen) == :true
      end

      def url_schemes
        result = []
        
        @config.url_scheme_set.each { |url_scheme|
          result << {
            :name => url_scheme.name || @config.package,
            :role => %w{Editor Viewer Shell None}.find{|u| u == url_scheme.role} || "None",
            :schemes => url_scheme.schemes
          }
        }
        
        result
      end

      def prerendered_icon?
        @config.preference("prerendered-icon") == :true
      end

      def statusbar_style
        pref = @config.preference("ios-statusbarstyle")
        if pref
          STATUS_BARS[pref]
        end
      end
    end
  end
end
