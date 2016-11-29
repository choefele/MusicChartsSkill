import Foundation
import AlexaSkillsKit
import AlexaSkill

do {
    let data = FileHandle.standardInput.readDataToEndOfFile()
    let alexaSkillsHandler = AlexaSkillHandler(chartsService: SpotifyChartsService())
    let requestDispatcher = RequestDispatcher(requestHandler: alexaSkillsHandler)
    let responseData = try requestDispatcher.dispatch(data: data)
    FileHandle.standardOutput.write(responseData)
} catch let error as AlexaSkillsKit.MessageError {
    let data = error.message.data(using: .utf8) ?? Data()
    FileHandle.standardOutput.write(data)
}
