#!/usr/bin/env bash
#Author:Andrei

#AMI_ID
AMI_ID=$1

#retrieve the snapshots associated with the AMI
Snap="$(aws ec2 describe-images --image-ids $AMI_ID --region us-east-1 --query 'Images[*].BlockDeviceMappings[*].Ebs.SnapshotId' --output text)"

echo ""
echo "Listing Snapshots...."
for SNAPSHOT in $Snap; do echo $SNAPSHOT; done
echo ""

#deregister the AMI
echo "Deregister the AMI...."
aws ec2 deregister-image --image-id $AMI_ID
if [ $? -eq 0 ]; then
    echo "Done."
else
    echo "Deregister failed"
fi
echo ""

#remove all the snapshots associated with that AMI
echo "Remove all the snapshots...."
for SNAPSHOT in $Snap; do aws ec2 delete-snapshot --snapshot-id $SNAPSHOT; done
if [ $? -eq 0 ]; then
    echo "Done."
else
    echo "Failed to remove"
fi
echo ""
