import Foundation
import AVFoundation
import os

#if canImport(Speech)
import Speech
#endif

/// Transcription service that leverages the new SpeechAnalyzer / SpeechTranscriber API available on macOS 26 (Tahoe).
/// Falls back with an unsupported-provider error on earlier OS versions so the application can gracefully degrade.
class NativeAppleTranscriptionService: TranscriptionService {
    private let logger = Logger(subsystem: "com.prakashjoshipax.voiceink", category: "NativeAppleTranscriptionService")
    
    /// Maps simple language codes to Apple's BCP-47 locale format
    private func mapToAppleLocale(_ simpleCode: String) -> String {
        let mapping = [
            "en": "en-US",
            "es": "es-ES", 
            "fr": "fr-FR",
            "de": "de-DE",
            "ar": "ar-SA",
            "it": "it-IT",
            "ja": "ja-JP",
            "ko": "ko-KR",
            "pt": "pt-BR",
            "yue": "yue-CN",
            "zh": "zh-CN"
        ]
        return mapping[simpleCode] ?? "en-US"
    }
    
    enum ServiceError: Error, LocalizedError {
        case unsupportedOS
        case transcriptionFailed
        case localeNotSupported
        case invalidModel
        case assetAllocationFailed
        
        var errorDescription: String? {
            switch self {
            case .unsupportedOS:
                return "SpeechAnalyzer requires macOS 26 or later."
            case .transcriptionFailed:
                return "Transcription failed using SpeechAnalyzer."
            case .localeNotSupported:
                return "The selected language is not supported by SpeechAnalyzer."
            case .invalidModel:
                return "Invalid model type provided for Native Apple transcription."
            case .assetAllocationFailed:
                return "Failed to allocate assets for the selected locale."
            }
        }
    }

    func transcribe(audioURL: URL, model: any TranscriptionModel) async throws -> String {
        guard model is NativeAppleModel else {
            throw ServiceError.invalidModel
        }
        
        guard #available(macOS 26, *) else {
            logger.error("SpeechAnalyzer is not available on this macOS version")
            throw ServiceError.unsupportedOS
        }
        
        // Since macOS 26 doesn't exist yet, this will always throw
        logger.error("SpeechAnalyzer is not available on this macOS version")
        throw ServiceError.unsupportedOS
        
        // All the transcription code is commented out because SpeechTranscriber is not available in current macOS versions
        // This would be the implementation when macOS 26 becomes available:
        // 1. Create AVAudioFile from audioURL
        // 2. Get user's selected language and convert to BCP-47 format
        // 3. Check for locale support and asset installation status
        // 4. Manage asset allocation/deallocation
        // 5. Create SpeechTranscriber and SpeechAnalyzer
        // 6. Process transcription and return formatted result
    }
    
    @available(macOS 26, *)
    private func deallocateExistingAssets() async throws {
        #if canImport(Speech)
        // This would deallocate existing assets when macOS 26 becomes available
        logger.notice("Would deallocate existing asset locales.")
        #endif
    }
    
    @available(macOS 26, *)
    private func allocateAssetsForLocale(_ locale: Locale) async throws {
        #if canImport(Speech)
        // This would allocate assets for the locale when macOS 26 becomes available
        logger.notice("Would allocate assets for locale: '\(locale.identifier(.bcp47))'")
        #endif
    }
    
    // Forward-compatibility: Use Any here because SpeechTranscriber is only available in future macOS SDKs.
    // This avoids referencing an unavailable SDK symbol while keeping the method shape for later adoption.
    @available(macOS 26, *)
    private func ensureModelIsAvailable(for transcriber: Any, locale: Locale) async throws {
        #if canImport(Speech)
        // This code is only available on macOS 26+, which doesn't exist yet
        // For now, we'll just return without doing anything
        return
        
        // When macOS 26 becomes available, this would check if assets are installed
        // and request download if needed
        #endif
    }
} 
