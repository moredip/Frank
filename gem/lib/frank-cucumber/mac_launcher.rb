require "timeout"

module Frank
    class MacLauncher

        def initialize(app_path)
            @app_path = app_path
        end

        def launch
            `open "#{@app_path}"`
        end

        def quit_if_running
            pid = `ps -ax | grep "#{@app_path}" | grep -v grep`

            if pid != ""
                pid = pid.strip.split[0]
                `kill #{pid}`
            end

            Timeout::timeout(60) {
                while pid != ""
                    pid = `ps -ax | grep "#{@app_path}" | grep -v grep`
                end
            }

        end

        def relaunch
            self.quit_if_running
            self.launch
        end
    end
end
