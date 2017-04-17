module.exports = function(grunt) {
    grunt.initConfig({
        concat: {
            js: {
                src: [
                    'bower_components/jquery/dist/jquery.min.js',
                    'bower_components/angular/angular.min.js',
                    'bower_components/angular-ui-router/release/angular-ui-router.min.js',
                    'bower_components/angular-cookie/angular-cookie.min.js',
                    'bower_components/bootstrap/dist/js/bootstrap.min.js',
                    'bower_components/lodash/dist/lodash.min.js',
                    'bower_components/restangular/dist/restangular.min.js',
                    'bower_components/angular-bootstrap/ui-bootstrap.min.js',
                    'bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js',
                    'bower_components/angular-google-maps/dist/angular-google-maps.min.js',
                    'bower_components/angular-notify/dist/angular-notify.min.js',
                ],
                dest: 'build/bower-dependencies.min.js',
        		nonull: true,
            },
            css: {
                src: [
                    'bower_components/bootstrap/dist/css/bootstrap.css',
                    'bower_components/angular-notify/dist/angular-notify.css',
                ],
                dest: 'build/bower-dependencies.css',
        		nonull: true,
            },
        },
        coffee: {
            compile: {
                files: {
                    'build/morphs.js': [
                        'morphs/morphs.coffee',
                        'morphs/**.coffee',
                        'nav/nav.coffee',
                        'nav/**.coffee',
                        'users/users.coffee',
                        'users/**.coffee',
                    ]
                }
            }
        },
        uglify: {
            options: {
                mangle: false
            },
            morphs: {
                files: {
                    'build/morphs.min.js': ['build/morphs.js']
                }
            }
        },
        watch: {
            files: ['**/*', '!node_modules/**.*', '!build/**.*'],
            tasks: ['default'],
        },
    });

    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['concat', 'coffee', 'uglify']);
};
