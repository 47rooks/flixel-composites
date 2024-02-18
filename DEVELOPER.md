# Developer Notes

This repo consists of a three directories configured as a VSCode multi-root workspace. The root dirs are:

   * composites
     * this is the flixel-composites package organized as a haxelib so it's easy to use in your project.
   * examples
     * this is an example flixel application demonstrating the features
   * tests
     * this is the unit tests using utest

The workspace file is called `composites.code-workspace` and you can open this project in vscode this way

```
code ./composites.code-workspace
```

There are build files for the `examples` and `tests`. In order to get vscode to recognise them you need to update `composites.code-workspace` to point to the directory and Project.xml that you want. You can either use an absolute path or a relative path. The relative path must work from the particular root dir, so it must being with `..\` as the lime extension will launch tasks in the directory containing the project file.