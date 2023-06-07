//
//  PostsMock.swift
//  Wish-I-WatchTests
//
//  Created by Toni Lozano Fernández on 7/6/23.
//

import Foundation

class PostsMock {
    static func makePostJsonMock() -> Data {
        return Data("""
   {
     "page": 1,
     "results": [
       {
         "adult": false,
         "backdrop_path": "/qnaQVbMiUuTezPIuXfcdlTeFU9d.jpg",
         "genre_ids": [
           18
         ],
         "id": 174958,
         "original_language": "de",
         "original_title": "Harakiri",
         "overview": "The daughter of a Daimyo, one forced to commit harakiri to secure her a future to choose her own destiny, falls in love with and marries a European officer. The officer returns to Europe but promises to come back for her and his new child, but when he comes back to Japan, he brings his European wife.",
         "popularity": 2.093,
         "poster_path": "/xDXMUdERs3uFtgO8P5J5WyWT554.jpg",
         "release_date": "1919-12-18",
         "title": "Harakiri",
         "video": false,
         "vote_average": 5.9,
         "vote_count": 17
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           18
         ],
         "id": 556415,
         "original_language": "fr",
         "original_title": "Hara-Kiri",
         "overview": "",
         "popularity": 0.6,
         "poster_path": "/gXOmXnDsPr2pW02gtLvBLvnPjcM.jpg",
         "release_date": "1928-11-23",
         "title": "Hara-Kiri",
         "video": false,
         "vote_average": 0.0,
         "vote_count": 0
       },
       {
         "adult": false,
         "backdrop_path": "/nC3IjYhUgZWgfKfFX0ygMigFwgc.jpg",
         "genre_ids": [
           28,
           18,
           36
         ],
         "id": 14537,
         "original_language": "ja",
         "original_title": "切腹",
         "overview": "Down-on-his-luck veteran Tsugumo Hanshirō enters the courtyard of the prosperous House of Iyi. Unemployed, and with no family, he hopes to find a place to commit seppuku—and a worthy second to deliver the coup de grâce in his suicide ritual. The senior counselor for the Iyi clan questions the ronin’s resolve and integrity, suspecting Hanshirō of seeking charity rather than an honorable end. What follows is a pair of interlocking stories which lay bare the difference between honor and respect, and promises to examine the legendary foundations of the Samurai code.",
         "popularity": 21.99,
         "poster_path": "/5konZnIbcAxZjP616Cz5o9bKEfW.jpg",
         "release_date": "1962-09-15",
         "title": "Harakiri",
         "video": false,
         "vote_average": 8.417,
         "vote_count": 785
       },
       {
         "adult": false,
         "backdrop_path": "/hZ2bSD5r15CD32B9j4Cvcbf2szc.jpg",
         "genre_ids": [
           18
         ],
         "id": 85836,
         "original_language": "ja",
         "original_title": "一命",
         "overview": "A tale of revenge, honor and disgrace, centering on a poverty-stricken samurai who discovers the fate of his ronin son-in-law, setting in motion a tense showdown of vengeance against the house of a feudal lord.",
         "popularity": 10.559,
         "poster_path": "/rqIqSoxbsVTfcr6CgTtSpzJBkYt.jpg",
         "release_date": "2011-10-15",
         "title": "Hara-Kiri: Death of a Samurai",
         "video": false,
         "vote_average": 7.259,
         "vote_count": 145
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           27
         ],
         "id": 398766,
         "original_language": "ja",
         "original_title": "女学生・腹切り",
         "overview": "A school girl kneels on her mat looking over an old photo album containing pictures of people committing seppuku. Becoming aroused by what she sees, she touches herself and licks her fingertips. She pulls out a knife of her own, takes off her uniform, and in a very fetishistic manner proceeds to slit open her stomach and then pull out her guts.",
         "popularity": 0.74,
         "poster_path": "/hbiCGIHSx4JB3tO5ZjgEXa0wVRQ.jpg",
         "release_date": "1990-01-01",
         "title": "School Girl: Harakiri",
         "video": false,
         "vote_average": 4.6,
         "vote_count": 5
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           27
         ],
         "id": 106138,
         "original_language": "ja",
         "original_title": "失楽園・乗馬服女腹切り",
         "overview": "Directed by Masami Akita,who is also one of Japan's leading noise musicians under the name Merzbow. With a soundtrack by the director himself, this intense and ultra-gory seppuku film shows a young woman taking her own life by an act of ritual harakiri.",
         "popularity": 0.6,
         "poster_path": null,
         "release_date": "1990-01-01",
         "title": "Lost Paradise: Riding Habit Harakiri",
         "video": false,
         "vote_average": 5.1,
         "vote_count": 9
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           27
         ],
         "id": 311676,
         "original_language": "ja",
         "original_title": "女腹切り・聖餐",
         "overview": "A woman in a nurse’s outfit sits in a dark room. She kneels on a mat and looks over a knife, touching it with her fingers and examining it. She runs the knife over her stocking clad legs and contemplates suicide. She plunges the blade into her abdominal region and pulls it across.",
         "popularity": 1.083,
         "poster_path": "/sc8XT5PvbBalf7fpBEesnbwnEM7.jpg",
         "release_date": "1990-01-01",
         "title": "Female Harakiri: Celebration",
         "video": false,
         "vote_average": 4.8,
         "vote_count": 6
       },
       {
         "adult": false,
         "backdrop_path": "/qYmMhPlqAma2gNXHgbgN7tvry9p.jpg",
         "genre_ids": [
           27
         ],
         "id": 390674,
         "original_language": "ja",
         "original_title": "女腹切り・散華",
         "overview": "Part of the Zankoku-bi: Onna harakiri 01 series.",
         "popularity": 0.782,
         "poster_path": "/vuBdh0TqmyT3964vAXXQYZbojmf.jpg",
         "release_date": "1989-01-01",
         "title": "Female Harakiri: Glorious Death",
         "video": false,
         "vote_average": 4.2,
         "vote_count": 4
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           27
         ],
         "id": 398768,
         "original_language": "ja",
         "original_title": "白装束・腹切り",
         "overview": "A black and white preface shows a woman in a traditional kimono climbing the stairs as WWII era Mitsubishi Zeros fly through the sky and footage of the Japanese military of the era is superimposed over the footage. She stops at the top of the stairs to say her prayers, rings a bell, and heads inside where the footage is shot in color. She unravels her kimono and rubs her face with the cloth before wrapping her blade and lovingly touching it. She pulls it across her stomach and slits herself open, falling to the mat. She crawls across the mat, dying, slipping in her own slick blood until she can't move anymore.",
         "popularity": 0.6,
         "poster_path": "/1DB5hzgwwUDAVi3zi96LaAR1Vh2.jpg",
         "release_date": "1990-01-01",
         "title": "White Clothing: Harakiri",
         "video": false,
         "vote_average": 4.7,
         "vote_count": 7
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           
         ],
         "id": 619820,
         "original_language": "ru",
         "original_title": "Харакири",
         "overview": "A young frustrated poet moves into an old communal apartment in Saint Petersburg. Incompetence leads him to the constant contemplation of a suicide and anticipation of a post-mortem fame. However, the apartment he’s settled in is not suitable for meeting one’s end because of the lack of hot water. It doesn’t bother the tenants since they’re too afraid of a mysthical ‘Babay’ (Boogeyman) allegedly killing everyone who dares to fix it. The protagonist refuses to accept these terms and challenges Babay confonting him in his own room.",
         "popularity": 0.6,
         "poster_path": null,
         "release_date": "2019-08-17",
         "title": "Harakiri",
         "video": false,
         "vote_average": 0.0,
         "vote_count": 0
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           35
         ],
         "id": 696327,
         "original_language": "en",
         "original_title": "Journal Bête Et Méchant Presente: Hara-Kiri N°1",
         "overview": "French magazine",
         "popularity": 0.6,
         "poster_path": null,
         "release_date": "1984-02-01",
         "title": "Journal Bête Et Méchant Presente: Hara-Kiri N°1",
         "video": false,
         "vote_average": 0.0,
         "vote_count": 0
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           
         ],
         "id": 726125,
         "original_language": "en",
         "original_title": "Hara-Kiri Canvas",
         "overview": "A painter trying to to finally make his masterpiece decides to risk it all.",
         "popularity": 0.6,
         "poster_path": null,
         "release_date": "",
         "title": "Hara-Kiri Canvas",
         "video": false,
         "vote_average": 0.0,
         "vote_count": 0
       },
       {
         "adult": false,
         "backdrop_path": null,
         "genre_ids": [
           10752,
           18,
           10749
         ],
         "id": 355147,
         "original_language": "fr",
         "original_title": "La Bataille",
         "overview": "The Battle is a 1934 Franco-British co-production English language drama film directed by Nicolas Farkas and Viktor Tourjansky, and starring Charles Boyer, Merle Oberon and John Loder. It was adapted from a novel by Claude Farrère. In 1904 during the Russo-Japanese War, a Japanese naval officer gets his wife to seduce a British atachee in order to gain secrets from him. Things begin to go wrong when she instead falls in love with him.",
         "popularity": 0.84,
         "poster_path": "/gtVxW8hrU5qYtSLvSvACWZShjSB.jpg",
         "release_date": "1934-05-11",
         "title": "La Bataille",
         "video": false,
         "vote_average": 7.0,
         "vote_count": 1
       }
     ],
     "total_pages": 1,
     "total_results": 13
   }
   """.utf8)
    }
    
    static func makePostEmptyResultJsonMock() -> Data {
        return Data("""
                {
                  "page": 1,
                  "results": [
                    
                  ],
                  "total_pages": 1,
                  "total_results": 0
                }
                """.utf8)
    }
}
