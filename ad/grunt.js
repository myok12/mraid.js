"use strict";
module.exports = function(grunt) {

    process.env.NODE_ENV = "test";

    // Add our custom tasks.
    //grunt.loadNpmTasks("grunt-coffeelint");
    grunt.loadNpmTasks("grunt-contrib-coffee");

    // Project configuration.
    grunt.initConfig({
        watch: {
            files: ["coffee/*.coffee"],
            tasks: ["coffee"]
            
        },
        coffee: {
            compile: {
                files: {
                    //"path/to/result.js": "path/to/source.coffee", // 1:1 compile
                    // compile and concat into single file
                    //"path/to/another.js": ["cof/to/sources/*.coffee", "path/to/more/*.coffee"], 
                    // compile individually into dest, maintaining folder structure
                    "js/*.js": ["coffee/*.coffee"] 
                }
            },
            /*
            flatten: {
                options: {
                    flatten: false
                },
                files: {
                    // compile individually into dest, flattening folder structure
                    "path/to/*.js": ["path/to/sources/*.coffee", "path/to/more/*.coffee"] 
                }
            }
            */
        }
    });
    
    //grunt.registerTask("default", "lint test");
    //grunt.registerTask("test", "prerun mochaTest");

};

