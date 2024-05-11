//
//  ExercisesDatabase.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import Foundation

enum BodyPart: String, Codable, CaseIterable {
    case legs = "legs"
    case back = "back"
    case chest = "chest"
    case shoulder = "shoulder"
    case arms = "arms"
    case core = "core"
    case fullBody = "full body"
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case dumbbell = "dumbbell"
    case barbell = "barbell"
    case machine = "machine"
    case bodyWeight = "body weight"
    case cardio = "cardio"
}

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let bodyPart: BodyPart
    let category: ExerciseCategory
    let description: String
    let imageUrl: String?
}

final class ExerciseDatabase {
    
    static let exercises: [DBExercise] = [
        DBExercise(id: "1",
           name: "Squat",
           bodyPart: .legs,
           category: .bodyWeight,
           description: "This bodyweight exercise targets the thighs, hips, buttocks, quads, and hamstrings. Stand with feet shoulder-width apart, lower into a squat position while keeping your chest up and back straight. This exercise is crucial for building lower body strength and improving flexibility.",
           imageUrl: "https://gymvisual.com/14082-large_default/bodyweight-pulse-squat.jpg"),
        DBExercise(id: "2",
           name: "Deadlift",
           bodyPart: .back,
           category: .barbell,
           description: "Involves lifting a loaded barbell from the ground to hip level then lowering it back down. This compound movement engages the back, glutes, and legs, enhancing posture and overall strength.",
           imageUrl: "https://gymvisual.com/34551-large_default/barbell-sumo-romanian-deadlift-female.jpg"),
        DBExercise(id: "3",
           name: "Bench Press",
           bodyPart: .chest,
           category: .barbell,
           description: "Targets the pectoral muscles by pressing a weight upwards from a bench-lying position. This essential upper body exercise also engages the shoulders and triceps, improving upper body strength and muscle mass.",
           imageUrl: "https://gymvisual.com/33869-large_default/barbell-wide-bench-press-female.jpg"),
        DBExercise(id: "4",
           name: "Shoulder Press",
           bodyPart: .shoulder,
           category: .bodyWeight,
           description: "Involves pressing weights upward from the shoulders, engaging the entire shoulder region. This bodyweight variant can be performed with resistance bands or light weights, enhancing shoulder strength and stability.",
           imageUrl: "https://gymvisual.com/34346-large_default/resistance-band-overhead-shoulder-press-version-2.jpg"),
        DBExercise(id: "5",
           name: "Biceps Curl",
           bodyPart: .arms,
           category: .dumbbell,
           description: "Focuses on the biceps by curling weights from a hanging position to shoulder height. This exercise is fundamental for building arm strength and muscle definition, ensuring balanced arm development.",
           imageUrl: "https://gymvisual.com/20395-large_default/dumbbell-waiter-biceps-curl.jpg"),
        DBExercise(id: "6",
           name: "Twist Crunch",
           bodyPart: .core,
           category: .bodyWeight,
           description: "Enhances core strength by twisting the upper body during a crunch, targeting the oblique muscles along with the abdominals. This variation increases the intensity of the traditional crunch, improving core stability and muscle tone.",
           imageUrl: "https://gymvisual.com/24291-large_default/twist-crunch-legs-up-male.jpg"),
        DBExercise(id: "7",
           name: "Burpees",
           bodyPart: .fullBody,
           category: .bodyWeight,
           description: "A dynamic full-body exercise that combines a squat, jump, and push-up. Excellent for building strength and endurance, it also boosts cardiovascular fitness and burns a significant amount of calories.",
           imageUrl: "https://gymvisual.com/33072-large_default/jack-burpee-male.jpg"),
        DBExercise(id: "8",
           name: "Leg Press",
           bodyPart: .legs,
           category: .machine,
           description: "argets the quadriceps, hamstrings, and glutes by using a machine to push weights with the legs. This exercise is vital for building leg strength and can be adjusted to different resistance levels to match fitness goals.",
           imageUrl: "https://gymvisual.com/34412-large_default/lever-angled-leg-press-male.jpg"),
        DBExercise(id: "9",
           name: "Lat Pulldown",
           bodyPart: .back,
           category: .machine,
           description: "Strengthens the latissimus dorsi and other back muscles by pulling a weighted bar towards the chest. This exercise is key for developing back strength and muscle mass, enhancing upper body conditioning.",
           imageUrl: "https://gymvisual.com/16618-large_default/cable-close-grip-front-lat-pulldown-female.jpg"),
        DBExercise(id: "10",
           name: "Pec Deck",
           bodyPart: .chest,
           category: .machine,
           description: "Isolates the chest muscles by moving arms against resistance in a fly motion. This machine exercise is excellent for sculpting and strengthening the pectorals without the strain on the shoulders typical with free weights.",
           imageUrl: "https://gymvisual.com/2928-large_default/lever-pec-deck-fly.jpg"),
        DBExercise(id: "11",
           name: "Lateral Raise",
           bodyPart: .shoulder,
           category: .machine,
           description: "Targets the shoulder muscles, particularly the lateral deltoids, by lifting weights out to the sides. This machine exercise ensures proper form and resistance adjustment, ideal for enhancing shoulder width and strength.",
           imageUrl: "https://gymvisual.com/14322-large_default/lever-lateral-raise-female.jpg"),
        DBExercise(id: "12",
           name: "Tricep Extension",
           bodyPart: .arms,
           category: .machine,
           description: "Strengthens the triceps by extending the arms against resistance. This can be performed using a machine to ensure proper form and focus on the tricep muscles, crucial for upper arm toning and strength.",
           imageUrl: "https://gymvisual.com/18915-large_default/band-overhead-triceps-extension-version-2-male.jpg"),
        DBExercise(id: "13",
           name: "Side Plank",
           bodyPart: .core,
           category: .bodyWeight,
           description: "A core strengthening exercise that involves maintaining a sideways position elevated on one arm. This variation challenges stability and engages the oblique muscles, enhancing core strength and balance.",
           imageUrl: "https://gymvisual.com/27545-large_default/side-plank-with-raised-leg-version-2-left-female.jpg"),
        DBExercise(id: "14",
           name: "Jump Rope",
           bodyPart: .fullBody,
           category: .cardio,
           description: "Improves cardiovascular health, coordination, and stamina by repetitive jumping over a rope. This intense cardio workout is excellent for burning calories and increasing agility.",
           imageUrl: "https://gymvisual.com/20632-large_default/3-4-sit-up.jpg"),
        DBExercise(id: "15",
           name: "Lunges",
           bodyPart: .legs,
           category: .bodyWeight,
           description: "Strengthens the legs and buttocks by stepping forward into a lunge position and lowering the hips. This bodyweight exercise enhances leg strength, balance, and coordination.",
           imageUrl: "https://gymvisual.com/2800-large_default/band-lunges.jpg"),
        DBExercise(id: "16",
           name: "Rowing",
           bodyPart: .back,
           category: .machine,
           description: "Simulates rowing a boat, engaging the back, arms, and cardiovascular system. This exercise is effective for building back strength and endurance while providing a vigorous cardio workout.",
           imageUrl: "https://gymvisual.com/8959-large_default/rowing-with-rowing-machine-female.jpg"),
        DBExercise(id: "17",
           name: "Push-ups",
           bodyPart: .chest,
           category: .bodyWeight,
           description: "Involves raising and lowering the body using the arms, targeting the chest, shoulders, and triceps. This fundamental bodyweight exercise enhances upper body strength and muscle definition.",
           imageUrl: "https://gymvisual.com/29971-large_default/wrist-push-up-male.jpg"),
        DBExercise(id: "18",
           name: "Dumbbell Flyes",
           bodyPart: .chest,
           category: .dumbbell,
           description: "Targets the chest muscles by moving dumbbells in an arc above the chest. This exercise is excellent for expanding the chest muscles and enhancing definition.",
           imageUrl: "https://gymvisual.com/18756-large_default/dumbbell-twisted-fly.jpg"),
        DBExercise(id: "19",
           name: "Hammer Curl",
           bodyPart: .arms,
           category: .dumbbell,
           description: "Focuses on the biceps and forearms by curling dumbbells with palms facing each other. This variant of the traditional curl helps in developing arm strength and muscle balance.",
           imageUrl: "https://gymvisual.com/20668-large_default/dumbbell-hammer-curl-female.jpg"),
        DBExercise(id: "20",
           name: "Leg Raises",
           bodyPart: .core,
           category: .bodyWeight,
           description: "Strengthens the lower abdominals by lifting the legs towards the ceiling while lying on the back. This exercise is essential for core strengthening and developing lower abdominal muscle tone.",
           imageUrl: "https://gymvisual.com/22504-large_default/lying-leg-raise-female.jpg"),
        DBExercise(id: "21",
           name: "Kettlebell Swing",
           bodyPart: .fullBody,
           category: .cardio,
           description: "Combines strength training with cardiovascular effort by swinging a kettlebell between the legs and up to chest height. This exercise boosts overall fitness, enhances endurance, and builds muscle.",
           imageUrl: "https://gymvisual.com/14645-large_default/kettlebell-overhand-grip-swing-female.jpg"),
        DBExercise(id: "22",
           name: "Treadmill Running",
           bodyPart: .legs,
           category: .cardio,
           description: "Provides a controlled cardio session that improves endurance and burns calories. Running on a treadmill allows for adjustable speeds and inclines to match fitness levels.",
           imageUrl: "https://gymvisual.com/8952-large_default/run-on-treadmill-female.jpg"),
        DBExercise(id: "23",
           name: "Back Extension",
           bodyPart: .back,
           category: .machine,
           description: "Strengthens the lower back muscles by lifting the upper body against resistance while lying face down. This exercise is critical for back health and core stability.",
           imageUrl: "https://gymvisual.com/19012-large_default/45-degrees-back-extension.jpg"),
        DBExercise(id: "24",
           name: "Cable Cross-over",
           bodyPart: .chest,
           category: .machine,
           description: "A chest exercise that involves pulling cables from opposite sides towards the middle, engaging the pectoral muscles intensely. Ideal for sculpting and strengthening the chest.",
           imageUrl: "https://gymvisual.com/33875-large_default/cable-standing-crossover-male.jpg"),
        DBExercise(id: "25",
           name: "Shrugs",
           bodyPart: .shoulder,
           category: .barbell,
           description: "Targets the upper trapezius muscles by lifting the shoulders towards the ears with weights in hand. This exercise is important for building neck and shoulder strength.",
           imageUrl: "https://gymvisual.com/22408-large_default/barbell-standing-snatch-grip-shrug.jpg"),
        DBExercise(id: "26",
           name: "Forearm Curl",
           bodyPart: .arms,
           category: .barbell,
           description: "Strengthens the forearms through a curling motion with a barbell, enhancing grip strength and forearm muscle development. Essential for comprehensive arm fitness.",
           imageUrl: "https://gymvisual.com/28172-large_default/barbell-wrist-curl-version-2.jpg"),
        DBExercise(id: "27",
           name: "Sit-ups",
           bodyPart: .core,
           category: .bodyWeight,
           description: "A classic core exercise that involves lifting the upper body from a lying position to sitting up, targeting the abdominal muscles effectively for enhanced core strength and stability.",
           imageUrl: "https://gymvisual.com/14643-large_default/sit-up-with-arms-on-chest.jpg"),
        DBExercise(id: "28",
           name: "Mountain Climbers",
           bodyPart: .fullBody,
           category: .bodyWeight,
           description: "Simulates a climbing motion in a plank position, rapidly driving knees towards the chest. This full-body workout improves cardiovascular fitness, core strength, and agility.",
           imageUrl: "https://gymvisual.com/26664-large_default/mountain-climber-female.jpg"),
        DBExercise(id: "29",
           name: "Stationary Cycling",
           bodyPart: .legs,
           category: .cardio,
           description: "Engages the legs in a cardio session on a stationary bike, enhancing leg strength and cardiovascular health. Adjustable resistance allows for tailored workouts to suit fitness goals.",
           imageUrl: "https://gymvisual.com/8740-large_default/stationary-bike-run-version-3.jpg"),
        DBExercise(id: "30",
           name: "Pull-ups",
           bodyPart: .back,
           category: .bodyWeight,
           description: "Strengthens the upper body, particularly the back and biceps, by pulling up on a bar until the chin surpasses it. This exercise is crucial for developing upper body strength and muscle mass.",
           imageUrl: "https://gymvisual.com/11613-large_default/rocky-pull-up-pulldown-female.jpg")
    ]
    
}
