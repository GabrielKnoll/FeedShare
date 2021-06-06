import ApolloCodegenLib
import ArgumentParser
import Foundation

// An outer structure to hold all commands and sub-commands handled by this script.
struct SwiftScript: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: """
        A swift-based utility for performing Apollo-related tasks.

        NOTE: If running from a compiled binary, prefix subcommands with `swift-script`. Otherwise use `swift run ApolloCodegen [subcommand]`.
        """,
        subcommands: [GenerateCode.self]
    )

    /// The sub-command to actually generate code.
    struct GenerateCode: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "generate",
            abstract: "Generates swift code from your schema + your operations based on information set up in the `GenerateCode` command."
        )

        mutating func run() throws {
            let fileStructure = try FileStructure()
            CodegenLogger.log("File structure: \(fileStructure)")

            // Create the Codegen options object. This default setup assumes `schema.json` is in the target root folder, all queries are in some kind of subfolder of the target folder and will output as a single file to `API.swift` in the target folder. For alternate setup options, check out https://www.apollographql.com/docs/ios/api/ApolloCodegenLib/structs/ApolloCodegenOptions/
            let codegenOptions = ApolloCodegenOptions(
                outputFormat: .singleFile(atFileURL: fileStructure.outputURL),
                urlToSchemaFile: fileStructure.schemaURL
            )

            // Actually attempt to generate code.
            try ApolloCodegen.run(
                from: fileStructure.sourceRootURL,
                with: fileStructure.cliFolderURL,
                options: codegenOptions
            )
        }
    }
}

// This will set up the command and parse the arguments when this executable is run.
SwiftScript.main()
