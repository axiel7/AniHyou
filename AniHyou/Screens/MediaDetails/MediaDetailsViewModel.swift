//
//  MediaDetailsViewModel.swift
//  AniHyou
//
//  Created by Axel Lopez on 19/6/22.
//

import Foundation

class MediaDetailsViewModel: ObservableObject {
    
    @Published var mediaDetails: MediaDetailsQuery.Data.Medium?
    
    func getMediaDetails(id: Int) {
        Network.shared.apollo.fetch(query: MediaDetailsQuery(mediaId: id)) { result in
            switch result {
            case .success(let graphQLResult):
                if let media = graphQLResult.data?.media {
                    self.mediaDetails = media
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    var genresFormatted: String? {
        guard mediaDetails != nil else { return nil }
        guard mediaDetails?.genres != nil else { return nil }
        return mediaDetails!.genres!.compactMap { $0 }.joined(separator: ", ")
    }
    
    /// Returns a string with the season and year if has it
    var seasonFormatted: String? {
        guard mediaDetails != nil else { return nil }
        guard mediaDetails?.season != nil else { return nil }
        if mediaDetails?.seasonYear != nil {
            return "\(mediaDetails!.season!.formatted) \(mediaDetails!.seasonYear!)"
        } else {
            return mediaDetails?.season?.formatted
        }
    }
    
    /// Returns a string with the studios comma separated
    var studiosFormatted: String? {
        guard mediaDetails != nil else { return nil }
        guard mediaDetails?.studios?.nodes != nil else { return nil }
        var strStudios = ""
        for studio in mediaDetails!.studios!.nodes! {
            if studio?.isAnimationStudio == true {
                if let name = studio?.name {
                    strStudios += "\(name), "
                }
            }
        }
        if strStudios.isEmpty { return nil }
        else { return String(strStudios.dropLast(2)) }
    }
    
    /// Returns a string with the producers comma separated
    var producersFormatted: String? {
        guard mediaDetails != nil else { return nil }
        guard mediaDetails?.studios?.nodes != nil else { return nil }
        var strProducers = ""
        for producer in mediaDetails!.studios!.nodes! {
            if producer?.isAnimationStudio == false {
                if let name = producer?.name {
                    strProducers += "\(name), "
                }
            }
        }
        if strProducers.isEmpty { return nil }
        else { return String(strProducers.dropLast(2)) }
    }
}
