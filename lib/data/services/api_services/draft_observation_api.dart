import 'package:project_one/data/models/draft_observation_model.dart';

class DraftObservationApi {
  Future<void> addDraftObservation(
    DraftObservationModel draftObservation,
  ) async {
    print(draftObservation.toJson());

    await Future.delayed(const Duration(seconds: 1));
  }

  Future<List<DraftObservationModel>> getDraftObservation() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      DraftObservationModel(
        id: 1,
        area: "Inventory",
        subject: "Inventory Audit",
        details: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        riskAndRootCause: "aaaaaaaaaaaaaaaaaaaaaaaa",
        recommendation: "ssssssssssssssssssssssssssssss",
        manageResponse: "cccccccccccccccccccccccccccc",
        correctiveActionPlan: "hhhhhhhhhhhhhhhhhhhhhh",
        actionTimeLine: 14,
        responsibleUserId: "R001",
        status: "close",
        remark: "rrrrrrrrrrrrrrrrrrrr",
        remarkedDate: "2026-05-30",
      ),

      DraftObservationModel(
        id: 2,
        area: "Financial",
        subject: "Financial Audit",
        details: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        riskAndRootCause: "aaaaaaaaaaaaaaaaaaaaaaaa",
        recommendation: "ssssssssssssssssssssssssssssss",
        manageResponse: "cccccccccccccccccccccccccccc",
        correctiveActionPlan: "hhhhhhhhhhhhhhhhhhhhhh",
        actionTimeLine: 7,
        responsibleUserId: "R002",
        status: "close",
        remark: "rrrrrrrrrrrrrrrrrrrr",
        remarkedDate: "2026-05-30",
      ),
    ];
  }
}
