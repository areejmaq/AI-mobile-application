
import 'package:doctro/cubit/cancer_cubit.dart';
import 'package:doctro/model/cancer_detection_model/cancer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancerScreeningScreen extends StatelessWidget {
  final String imgUrl;
  final String patient;
  const CancerScreeningScreen({super.key, required this.imgUrl, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dermatological AI Assessment"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: BlocBuilder<CancerCubit, CancerState>(
        builder: (context, state) {
          if (state is CancerLoading) {
            return _buildAnalysisInProgress();
          } else if (state is CancerFailure) {
            return _buildErrorState(state.message, context);
          } else if (state is CancerSuccess) {
            return _buildDiagnosisResult(state.cancerResult, context);
          }
          return _buildInitialScreen(context,patient);
        },
      ),
    );
  }

  Widget _buildInitialScreen(BuildContext context,String patient) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ai_med.png', // Replace with your asset
            height: 180,
          ),
          const SizedBox(height: 32),
          Text(
            "AI-Powered Skin Lesion Analysis",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Upload a clear image of the skin lesion for preliminary malignancy assessment. "
            "Our deep learning model will provide a diagnostic prediction.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (imgUrl == "assets/images/no_image.jpg") Center(child: Text("Sorry But AI Diagnosis for $patient is not available since they haven't uploaded their picture yet.",maxLines: 4,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.red,fontSize: 22)))
          else ElevatedButton.icon(
            icon: const Icon(Icons.person),
            label: Text("Diagnose $patient"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.blue.shade700,
            ),
            onPressed: () => _handleImageUpload(context,imgUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisInProgress() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 24),
          Text(
            "Analyzing Lesion",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Processing image through our diagnostic model...",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              "Analysis Failed",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<CancerCubit>().reset(),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisResult(CancerModel result, BuildContext context) {
    final isMalignant = result.label.toLowerCase() == 'malignant';
    final confidencePercentage =
        (result.confidence_score * 100).toStringAsFixed(1);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              isMalignant ? Icons.warning_amber : Icons.verified,
              size: 72,
              color: isMalignant ? Colors.orange : Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              "Diagnostic Assessment",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Prediction:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.label,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isMalignant ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LinearProgressIndicator(
                    value: result.confidence_score,
                    backgroundColor: Colors.grey.shade300,
                    color: isMalignant ? Colors.orange : Colors.green,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Confidence: $confidencePercentage%",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              isMalignant
                  ? "This preliminary assessment suggests malignant characteristics. "
                      "Please consult with a specialist for further evaluation."
                  : "This preliminary assessment suggests benign characteristics. "
                      "Regular monitoring is still recommended.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.read<CancerCubit>().reset(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.blue.shade700),
                    ),
                    child: Text(
                      "New Analysis",
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Disclaimer: This AI assessment is for preliminary screening only "
              "and should not replace professional medical evaluation.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleImageUpload(BuildContext context, String imgUrl) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  
  try {
    
    context.read<CancerCubit>().processImage(imgUrl);

  } catch (e) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('Error selecting image: ${e.toString()}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
}
