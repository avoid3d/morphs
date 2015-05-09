module.exports = function(grunt) {
    grunt.initConfig({
        uglify: {
            options: {
                mangle: false
            },
            morphs: {
                files: {
                    'morphs.min.js': []
                }
            }
        },
        concat: {
            morphs: {
                src: [
                    'bower_components/jquery/dist/jquery.min.js',
                    'bower_components/bootstrap/dist/js/bootstrap.min.js',
                ],
                dest: 'build/bower-dependencies.min.js',
            },
        },
    });

    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');

    grunt.registerTask('default', ['concat']);
};
