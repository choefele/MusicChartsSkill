import PackageDescription

var package = Package(
    name: "AlexaSkill",
    targets: [
        Target(name: "AlexaSkill"),
        Target(name: "Lambda", dependencies: ["AlexaSkill"])
    ],
    dependencies: [
        .Package(url: "https://github.com/choefele/AlexaSkillsKit", majorVersion: 0),
        .Package(url: "https://github.com/yaslab/CSV.swift", majorVersion: 1, minor: 1)
    ],
    exclude: ["Sources/Server"])

#if os(macOS)
package.targets.append(Target(name: "Server", dependencies: ["AlexaSkill"]))
package.dependencies.append(.Package(url: "https://github.com/IBM-Swift/Kitura", majorVersion: 1, minor: 2))
package.dependencies.append(.Package(url: "https://github.com/IBM-Swift/HeliumLogger", majorVersion: 1, minor: 1))
package.exclude = []
#else
package.dependencies.append(.Package(url: "https://github.com/IBM-Swift/Kitura-net", majorVersion: 1, minor: 2))
#endif
