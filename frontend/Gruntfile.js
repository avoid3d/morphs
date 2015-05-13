module.exports = function(grunt) {
    grunt.initConfig({
        concat: {
            morphs: {
                src: [
                    'bower_components/jquery/dist/jquery.min.js',
                    'bower_components/angular/angular.min.js',
                    'bower_components/angular-ui-router/release/angular-ui-router.min.js',
                    'bower_components/bootstrap/dist/js/bootstrap.min.js',
                    'bower_components/lodash/lodash.min.js',
                    'bower_components/restangular/dist/restangular.min.js',
                ],
                dest: 'build/bower-dependencies.min.js',
            },
        },
        coffee: {
            compile: {
                files: {
                    'build/morphs.js': [
                        'common/common.coffee',
                        'common/**.*',
                        'nav/nav.coffee',
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
