/*

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
*/

'use strict';

module.exports = function (grunt) {

    // Load grunt tasks automatically
    require('load-grunt-tasks')(grunt);

    // Time how long tasks take. Can help when optimizing build times
    require('time-grunt')(grunt);

    var all_js_files = [
        'libs/jquery/dist/jquery.js',
        'js/utils/*\.js',
        'libs/twbs-bootstrap-sass/vendor/assets/javascripts/bootstrap/tooltip.js',
        'libs/twbs-bootstrap-sass/vendor/assets/javascripts/bootstrap/modal.js',
        'libs/twbs-bootstrap-sass/vendor/assets/javascripts/bootstrap/transition.js',
        'libs/twbs-bootstrap-sass/vendor/assets/javascripts/bootstrap/popover.js',
        'libs/twbs-bootstrap-sass/vendor/assets/javascripts/bootstrap/collapse.js',
        'libs/twbs-bootstrap-sass/vendor/assets/javascripts/bootstrap/tab.js',
        'libs/flot/jquery.flot.js',
        'libs/flot/jquery.flot.pie.js',
        'libs/flot/jquery.flot.categories.js',
        'libs/flot/jquery.flot.stack.js',
        'libs/typeahead.js/dist/typeahead.jquery.js',
        'js/blurconsole.js',
        'js/*\.js'
    ];

    // Define the configuration for all the tasks
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        banner: grunt.file.read('banner'),

        clean: ['public'],

        bower: {
            install: {
                options: {
                    targetDir: './libs',
                    install: true,
                    copy: false,
                    quiet: true
                }
            },
            prune: {
                options: {
                    targetDir: './libs',
                    copy: false,
                    offline: true,
                    quiet: true
                }
            }
        },

        // Compiles Sass to CSS and generates necessary files if requested
        sass: {
            options: {
                sourcemap: true,
                lineNumbers: true,
                loadPath: ['libs']
            },
            development: {
                files: {
                    'public/css/blurconsole.css': 'sass/blurconsole.scss'
                }
            },
            production: {
                files: {
                    'public/css/blurconsole.css': 'sass/blurconsole.scss'
                },
                options: {
                    style: 'compressed'
                }
            }
        },

        uglify: {
            js: {
                options: {
                    sourceMap: true,
                    sourceMapIncludeSources: true,
                    banner:'/*\n<%= banner %>\n*/',
                    compress: {
                        drop_console: true
                    }
                },
                files: {
                    'public/js/blurconsole.js': all_js_files
                }
            }
        },

        // Make sure code styles are up to par and there are no obvious mistakes
        jshint: {
            options: {
                jshintrc: true,
            },
            development: {
                src: ['js/**/*\.js', '!js/utils/**/*\.js']
            },
            ci: {
                src: ['js/**/*\.js'],
                options: {
                    reporter: 'checkstyle',
                    reporterOutput: 'build/jshint-checkstyle.xml'
                }
            }
        },

        // Watches files for changes and runs tasks based on the changed files
        watch: {
            options: {
                dateFormat: function(time) {
                    grunt.log.ok('The watch finished in ' + (time / 1000).toFixed(2) + 's. Waiting...');
                },
                spawn: false,
                interrupt: false
            },
            css: {
                files: ['sass/**/*.scss', 'libs/**/*.css', 'libs/**/*.scss'],
                tasks: ['sass:development', 'version-assets-css-map', 'version-assets-css', 'notify:css']
            },
            js: {
                files: ['js/**/*.js'],
                tasks: ['jshint:development', 'uglify:js', 'version-assets-js-map', 'version-assets-js']
            },
            html: {
                files: ['index.html', 'views/*.html'],
                tasks: ['copy:main', 'version-assets']
            },
            livereload: {
                options: {
                    livereload: '<%= connect.options.livereload %>'
                },
                files: [
                    './{,*/}*.html',
                    './img/{,*/}*.{gif,jpeg,jpg,png,svg,webp}'
                ]
            }
        },

        notify: {
            css: {
                options: {
                    title: 'Blur Console',
                    message: 'Sass finished'
                }
            }
        },

        mochaSelenium: {
            options: {
                screenshotAfterEach: true,
                screenshotDir: 'test/reports',
                reporter: 'spec',
                viewport: { width: 900, height: 700 },
                timeout: 30e3,
                slow: 10e3,
                implicitWaitTimeout: 100,
                asyncScriptTimeout: 5000,
                usePromises: true,
                useChaining: true,
                ignoreLeaks: false
            },
            firefox: { src: ['test/functional/spec/**/*.js'], options: { browserName: 'firefox' } },
            chrome: { src: ['text/function/spec/**/*.js'], options: { browserName: 'chrome' } }
        },

        karma: {
            unit: {
                configFile: 'karma.conf.js',
                runnerPort: 9999,
                singleRun: true
            }
        },

        connect: {
            options: {
                port: 3000,
                livereload: 4000,
                // Change this to '0.0.0.0' to access the server from outside
                hostname: '0.0.0.0',
                base: 'public'
            },
            livereload: {
                options: {
                    open: 'http://0.0.0.0:3000/?fakeIt=true'
                }
            }
        },

        copy: {
            main: {
                files: [
                    {expand: true, src: ['index.html','img/*','views/*'], dest: 'public/'},
                    {expand: true, flatten: true, src: ['libs/modernizr/modernizr.js'], dest: 'public/js'},
                    {expand: true, flatten: true, src: ['libs/twbs-bootstrap-sass/vendor/assets/fonts/bootstrap/*'], dest: 'public/css'}
                ]
            }
        }
    });

    grunt.loadNpmTasks('grunt-bower-task');
    grunt.loadNpmTasks('grunt-exec');
    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-notify');
    grunt.loadNpmTasks('grunt-mocha-selenium');
    grunt.loadNpmTasks('grunt-karma');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-copy');

    var initialHintSrc = grunt.config('jshint.development.src');
    grunt.event.on('watch', function(action, filepath){
        var matchingHint = grunt.file.match(initialHintSrc, filepath);
        grunt.config('jshint.development.src', matchingHint);
    });

    grunt.registerTask('deps', 'Install Webapp Dependencies', ['bower:install', 'bower:prune']);
    grunt.registerTask('test:functional:chrome', 'Run JavaScript Functional Tests in Chrome', ['mochaSelenium:chrome']);
    grunt.registerTask('test:functional:firefox', 'Run JavaScript Functional Tests in Firefox', ['mochaSelenium:firefox']);
    grunt.registerTask('test:functional', 'Run JavaScript Functional Tests', ['test:functional:chrome', 'test:functional:firefox']);
    grunt.registerTask('test:unit', 'Run JavaScript Unit Tests', ['karma']);
    grunt.registerTask('test:style', 'Run JavaScript CodeStyle reports', ['jshint:ci'/*, 'plato:ci' */]);
    grunt.registerTask('style:development', 'Run JavaScript CodeStyle reports', ['jshint:development']);
    grunt.registerTask('development', 'Build for development', ['clean', 'sass:development', 'uglify:js', 'copy:main', 'version-assets']);
    grunt.registerTask('production', 'Build for production', ['clean', 'sass:production', 'uglify:js', 'copy:main', 'version-assets']);
    grunt.registerTask('serve', 'Run development server', ['clean','development', 'connect:livereload','watch']);
    grunt.registerTask('default', ['clean', 'style:development', 'development', 'watch']);
    grunt.registerTask('version-assets-css-map', function() {
        var Version = require("node-version-assets");
        var versionInstance = new Version({
            assets: ['public/css/blurconsole.css.map'],
            grepFiles: ['public/css/blurconsole.css'],
            keepOriginal: true
        });
        versionInstance.run(this.async());
    });
    grunt.registerTask('version-assets-js-map', function() {
        var Version = require("node-version-assets");
        var versionInstance = new Version({
            assets: ['public/js/blurconsole.js.map'],
            grepFiles: ['public/js/blurconsole.js'],
            keepOriginal: true
        });
        versionInstance.run(this.async());
    });
    grunt.registerTask('version-assets-js', function() {
        var Version = require("node-version-assets");
        var versionInstance = new Version({
            assets: ['public/js/blurconsole.js'],
            grepFiles: ['public/index.html'],
            keepOriginal: true
        });
        versionInstance.run(this.async());
    });
    grunt.registerTask('version-assets-css', function() {
        var Version = require("node-version-assets");
        var versionInstance = new Version({
            assets: ['public/css/blurconsole.css'],
            grepFiles: ['public/index.html'],
            keepOriginal: true
        });
        versionInstance.run(this.async());
    });
    grunt.registerTask('version-assets', 'version the static assets just created', ['version-assets-js-map', 'version-assets-js', 'version-assets-css-map', 'version-assets-css']);
};
