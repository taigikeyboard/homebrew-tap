cask "taigikeyboard" do
  version "3.6.9"
  sha256 "ea77e1e1530556a716feec62c14bb9db2e2f3814616a308a7c62631b6f12708a"

  url "https://github.com/taigikeyboard/taigikeyboard/releases/download/desktop-#{version}/TaigiKeyboard-#{version}.pkg"
  name "TaigiKeyboard"
  desc "Taiwanese input method (POJ / TL / TPS, Hanji)"
  homepage "https://github.com/taigikeyboard/taigikeyboard"

  # Desktop releases share one tag across macOS / Windows / Linux, and some are
  # platform-only patches. Only a published release carrying a macOS .pkg counts.
  livecheck do
    url :url
    regex(/^TaigiKeyboard[._-]v?(\d+(?:\.\d+)+)\.pkg$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  auto_updates true
  depends_on macos: :sonoma

  pkg "TaigiKeyboard-#{version}.pkg"

  uninstall pkgutil: "com.siansiansu.inputmethod.TaigiKeyboard",
            delete:  "/Library/Input Methods/TaigiKeyboard.app"
end
