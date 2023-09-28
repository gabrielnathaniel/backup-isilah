//helper
import 'package:isilahtitiktitik/constant/constant.dart';

const String regionUrl = "$baseUrl/helper/region/postal";
const String provinceUrl = "$baseUrl/helper/region/province";
const String cityUrl = "$baseUrl/helper/region/regency";
const String subdistrictUrl = "$baseUrl/helper/region/subdistrict";
const String urbanVillageUrl = "$baseUrl/helper/region/urban_village";
const String versionUrl = "$baseUrl/version";
const String profesiUrl = "$baseUrl/helper/user/profession";
const String regionByPostalcodeUrl = "$baseUrl/helper/region/postal";
const String getListLevel = '/helper/user/level';

// Single User
const String getSingleUser = '/my/profile';
// Username Check
const String getUsernameCheck = '/my/profile/username/update/cek';
const String postUsernameUpdate = '/my/profile/username/update';

// Update Email
const String updateEmailOne = '/my/profile/email/update/one';
const String updateEmailResend = '/my/profile/email/update/resend';
const String updateEmailTwo = '/my/profile/email/update/two';
const String updateEmailFinish = '/my/profile/email/update/finish';

// Ranks
const String leaderboardAllTime = '/leaderboard';
const String leaderboardToday = '/leaderboard/today';
const String leaderboardWeekly = '/leaderboard/weekly';
const String leaderboardMonthly = '/leaderboard/monthly';

// User Ranks
const String userLeaderboard = '/my/leaderboard';

// Fun Facts
const String getFunFact = '/artikel/available';
const String getFunFactPantun = '$baseUrl/my/splash_page';

// Quiz
const String getDailyEvent = '/quiz/user_daily_event';
const String playQuiz = '/quiz/play';
const String finishQuiz = '/quiz/finish';
const String reaction = '/reaction';
const String questionIdUrl = '/question/view';

//referral
const String referralStep = '/my/refferal/prize';
const String referralUser = '/my/refferal';
const String referralRedeem = '/my/refferal/prize/redeem';

// Prize
const String getPrize = '/prize';
const String getPrizeNextLevel = '/prize/next_level';
const String claimPrizeStepOne = '/prize/claim_step_one';
const String claimPrizeStepTwo = '/prize/claim_step_two';
const String claimPrizeFinish = '/prize/claim';
const String claimHistories = '/prize/claim_histories';
const String getWinner = '/prize/winner';
const String getWinnerView = '/prize/winner/view';

// Frient
const String getFriendData = '/my/friend/profile';

// notification
const String getNotification = '/my/notification';
const String getNotificationRead = '/my/notification_read';

// Game
const String getListGame = '/game';
const String finishGame = '/game/done';

// Promo
const String getListPromo = '/ads/available';

//History
const String getHistory = '/my/mutation';

// Treasure Chest
const String treasureChestList = '/event/treasure_chest';
const String detailTreasureChest = '/event/detail';
const String joinTreasureChest = '/event/join';
const String startTreasureChest = '/event/quiz/start';
const String answerTreasureChest = '/event/quiz/answer';
const String resultTreasureChest = '/event/quiz/last_result';
const String leaderboardTreasureChest = '/event/leaderboard';
const String leaderboardTreasureChestMine = '/event/leaderboard_mine';

//FAQ
const String getFaq = '/faq/available';
