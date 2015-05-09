module.exports = function(grunt) {
    grunt.initConfig({
        concat: {
            morphs: {
                src: [
                    'bower_components/jquery/dist/jquery.min.js',
                    'bower_components/angular/angular.min.js',
                    'bower_components/bootstrap/dist/js/bootstrap.min.js',
                ],
                dest: 'build/bower-dependencies.min.js',
            },
        },
        coffee: {
            compile: {
                files: {
                    'build/morphs.js': [
                        'common/common.coffee',
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
    });

    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');

    grunt.registerTask('default', ['concat', 'coffee', 'uglify']);
};
